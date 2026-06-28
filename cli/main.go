package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strconv"
	"strings"
	"text/tabwriter"
)

// ANSI colors for styling
const (
	Reset     = "\033[0m"
	Bold      = "\033[1m"
	Red       = "\033[31m"
	Green     = "\033[32m"
	Yellow    = "\033[33m"
	Blue      = "\033[34m"
	Magenta   = "\033[35m"
	Cyan      = "\033[36m"
	Gray      = "\033[37m"
	LightGray = "\033[90m"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	subcommand := os.Args[1]
	switch subcommand {
	case "list", "ls":
		handleList()
	case "switch", "select":
		if len(os.Args) < 3 {
			fmt.Printf("%sError: missing theme name.%s\nUsage: theme switch <theme-name>\n", Red, Reset)
			os.Exit(1)
		}
		handleSwitch(os.Args[2])
	case "current", "status":
		handleCurrent()
	case "set":
		if len(os.Args) < 4 {
			fmt.Printf("%sError: missing key or value.%s\nUsage: theme set <key> <value>\n", Red, Reset)
			os.Exit(1)
		}
		handleSet(os.Args[2], os.Args[3])
	case "fonts", "font":
		handleFonts()
	case "options", "keys":
		handleOptions()
	case "secret":
		handleSecret()
	case "help", "-h", "--help":
		printUsage()
	default:
		fmt.Printf("%sUnknown command: %s%s\n", Red, subcommand, Reset)
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Printf("%s%sNixdots Theme Manager%s\n", Bold, Cyan, Reset)
	fmt.Println("A Go CLI wrapper for managing user-specific desktop themes and encrypted secrets.")
	fmt.Println()
	fmt.Printf("%sUsage:%s\n", Bold, Reset)
	fmt.Println("  theme <command> [arguments]")
	fmt.Println()
	fmt.Printf("%sTheme Commands:%s\n", Bold, Reset)
	fmt.Printf("  %slist / ls%s                   List all available theme presets\n", Green, Reset)
	fmt.Printf("  %sswitch / select <name>%s      Switch to a predefined theme preset\n", Green, Reset)
	fmt.Printf("  %scurrent / status%s            Display details of the active theme\n", Green, Reset)
	fmt.Printf("  %sset <key> <value>%s           Update a specific setting in the active theme\n", Green, Reset)
	fmt.Printf("  %sfonts / font%s                List all supported font families mapped in Nix\n", Green, Reset)
	fmt.Printf("  %soptions / keys%s              List all available theme config keys\n", Green, Reset)
	fmt.Println()
	fmt.Printf("%sSecrets Commands:%s\n", Bold, Reset)
	fmt.Printf("  %ssecret <command>%s            Manage encrypted credentials in the repository\n", Green, Reset)
	fmt.Println()
	fmt.Printf("%sExamples:%s\n", Bold, Reset)
	fmt.Println("  theme list")
	fmt.Println("  theme switch tokyonight")
	fmt.Println("  theme set colors.accent \"#ff0055\"")
	fmt.Println("  theme secret list")
	fmt.Println("  theme secret unlock")
}

// Helper to retrieve paths for user configuration
func getPaths() (string, string, string, string) {
	usr, err := user.Current()
	if err != nil {
		fmt.Printf("%sError getting current user: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	homeDir := usr.HomeDir
	username := usr.Username

	nixdotsDir := filepath.Join(homeDir, "nixdots")
	themeDir := filepath.Join(nixdotsDir, "theme")
	activeThemePath := filepath.Join(nixdotsDir, fmt.Sprintf("theme.%s.json", username))

	return username, nixdotsDir, themeDir, activeThemePath
}

// Read JSON file into map
func readJSONMap(path string) (map[string]interface{}, error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var res map[string]interface{}
	err = json.Unmarshal(data, &res)
	return res, err
}

// Write map back to JSON file
func writeJSONMap(path string, m map[string]interface{}) error {
	data, err := json.MarshalIndent(m, "", "  ")
	if err != nil {
		return err
	}
	return ioutil.WriteFile(path, data, 0644)
}

// Recursively traverse and set nested map key
func setNestedValue(m map[string]interface{}, path []string, value string) error {
	if len(path) == 0 {
		return fmt.Errorf("empty path")
	}

	key := path[0]
	if len(path) == 1 {
		// Set leaf value with type auto-detection
		if b, err := strconv.ParseBool(value); err == nil {
			m[key] = b
		} else if i, err := strconv.Atoi(value); err == nil {
			m[key] = i
		} else if f, err := strconv.ParseFloat(value, 64); err == nil {
			m[key] = f
		} else {
			m[key] = value
		}
		return nil
	}

	sub, exists := m[key]
	if !exists {
		sub = make(map[string]interface{})
		m[key] = sub
	}

	subMap, ok := sub.(map[string]interface{})
	if !ok {
		subMap = make(map[string]interface{})
		m[key] = subMap
	}

	return setNestedValue(subMap, path[1:], value)
}

func handleList() {
	username, _, themeDir, activeThemePath := getPaths()

	// Find the current active theme name
	activeThemeName := "Unknown"
	if activeMap, err := readJSONMap(activeThemePath); err == nil {
		if name, ok := activeMap["name"].(string); ok {
			activeThemeName = name
		}
	}

	files, err := ioutil.ReadDir(themeDir)
	if err != nil {
		fmt.Printf("%sError reading theme presets: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("\nAvailable Theme Presets (User: %s%s%s):\n\n", Bold, username, Reset)

	w := tabwriter.NewWriter(os.Stdout, 0, 0, 3, ' ', 0)
	fmt.Fprintf(w, "%sNAME\tFILE\tSTATUS%s\n", Bold, Reset)

	for _, file := range files {
		if !file.IsDir() && strings.HasSuffix(file.Name(), ".json") {
			filePath := filepath.Join(themeDir, file.Name())
			themeMap, err := readJSONMap(filePath)
			if err != nil {
				continue
			}

			themeName, _ := themeMap["name"].(string)
			presetName := strings.TrimSuffix(file.Name(), ".json")

			status := ""
			if themeName == activeThemeName {
				status = fmt.Sprintf("%s* active%s", Green, Reset)
				themeName = fmt.Sprintf("%s%s%s", Bold, themeName, Reset)
				presetName = fmt.Sprintf("%s%s%s", Bold, presetName, Reset)
			}

			fmt.Fprintf(w, "%s\t%s\t%s\n", themeName, presetName, status)
		}
	}
	w.Flush()
	fmt.Println()
}

func handleSwitch(themeName string) {
	username, nixdotsDir, themeDir, activeThemePath := getPaths()

	presetFile := filepath.Join(themeDir, fmt.Sprintf("%s.json", themeName))
	if _, err := os.Stat(presetFile); os.IsNotExist(err) {
		fmt.Printf("%sError: Theme preset '%s' not found under %s.%s\n", Red, themeName, themeDir, Reset)
		os.Exit(1)
	}

	fmt.Printf("Switching theme to '%s%s%s' for user '%s%s%s'...\n", Bold, themeName, Reset, Bold, username, Reset)

	// Copy preset JSON content to active user-specific theme JSON
	data, err := ioutil.ReadFile(presetFile)
	if err != nil {
		fmt.Printf("%sError reading preset: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	err = ioutil.WriteFile(activeThemePath, data, 0644)
	if err != nil {
		fmt.Printf("%sError writing active theme config: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("%sTheme config updated successfully at %s.%s\n", Green, activeThemePath, Reset)
	runHomeManagerSwitch(username, nixdotsDir)
}

func handleCurrent() {
	_, _, _, activeThemePath := getPaths()

	if _, err := os.Stat(activeThemePath); os.IsNotExist(err) {
		fmt.Printf("%sNo active theme configuration found at %s. Please select a theme first.%s\n", Yellow, activeThemePath, Reset)
		os.Exit(1)
	}

	data, err := ioutil.ReadFile(activeThemePath)
	if err != nil {
		fmt.Printf("%sError reading active theme: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Println()
	fmt.Printf("%s%sActive Theme Settings:%s\n", Bold, Cyan, Reset)
	fmt.Println(string(data))
}

func handleSet(keyPath string, value string) {
	username, nixdotsDir, _, activeThemePath := getPaths()

	if _, err := os.Stat(activeThemePath); os.IsNotExist(err) {
		fmt.Printf("%sNo active theme found at %s. Creating new settings...%s\n", Yellow, activeThemePath, Reset)
		// Try to create from default catppuccin
		defaultPreset := filepath.Join(nixdotsDir, "theme", "catppuccin.json")
		if data, err := ioutil.ReadFile(defaultPreset); err == nil {
			_ = ioutil.WriteFile(activeThemePath, data, 0644)
		} else {
			// Write empty map if preset unavailable
			_ = ioutil.WriteFile(activeThemePath, []byte("{}"), 0644)
		}
	}

	themeMap, err := readJSONMap(activeThemePath)
	if err != nil {
		fmt.Printf("%sError parsing active theme JSON: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	parts := strings.Split(keyPath, ".")
	err = setNestedValue(themeMap, parts, value)
	if err != nil {
		fmt.Printf("%sError setting value: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	err = writeJSONMap(activeThemePath, themeMap)
	if err != nil {
		fmt.Printf("%sError saving active theme JSON: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("%sUpdated %s to %q successfully in active theme.%s\n", Green, keyPath, value, Reset)
	runHomeManagerSwitch(username, nixdotsDir)
}

func handleFonts() {
	fmt.Println()
	fmt.Printf("%s%sSupported Fonts in Nix (Lazy Installation):%s\n", Bold, Cyan, Reset)
	fmt.Println("You can set any of these fonts in your theme JSON file.")
	fmt.Println()
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 3, ' ', 0)
	fmt.Fprintf(w, "%sFONT FAMILY\tNIX PACKAGE%s\n", Bold, Reset)
	fmt.Fprintln(w, "IBM Plex Sans\tpkgs.ibm-plex")
	fmt.Fprintln(w, "IBM Plex Serif\tpkgs.ibm-plex")
	fmt.Fprintln(w, "JetBrainsMono Nerd Font\tpkgs.nerd-fonts.jetbrains-mono")
	fmt.Fprintln(w, "FiraCode Nerd Font\tpkgs.nerd-fonts.fira-code")
	fmt.Fprintln(w, "Hack Nerd Font\tpkgs.nerd-fonts.hack")
	fmt.Fprintln(w, "Iosevka Nerd Font\tpkgs.nerd-fonts.iosevka")
	fmt.Fprintln(w, "Mononoki Nerd Font\tpkgs.nerd-fonts.mononoki")
	fmt.Fprintln(w, "Inter\tpkgs.inter")
	fmt.Fprintln(w, "Roboto\tpkgs.roboto")
	fmt.Fprintln(w, "Comic Mono\tpkgs.comic-mono")
	w.Flush()
	fmt.Println()
}

func handleOptions() {
	fmt.Println()
	fmt.Printf("%s%sAvailable Theme Configuration Keys:%s\n", Bold, Cyan, Reset)
	fmt.Println("Use these paths with `theme set <key> <value>`:")
	fmt.Println()
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 3, ' ', 0)
	fmt.Fprintf(w, "%sKEY PATH\tTYPE\tDESCRIPTION%s\n", Bold, Reset)
	fmt.Fprintln(w, "name\tstring\tTheme display name")
	fmt.Fprintln(w, "colors.background\tstring (hex)\tMain backgrounds")
	fmt.Fprintln(w, "colors.background_rgba\tstring (rgba)\tTransparent widgets")
	fmt.Fprintln(w, "colors.foreground\tstring (hex)\tPrimary text color")
	fmt.Fprintln(w, "colors.foreground_rgb\tstring (rgb)\tHyprlock labels")
	fmt.Fprintln(w, "colors.accent\tstring (hex)\tActive border highlight")
	fmt.Fprintln(w, "colors.accent_rgba\tstring (rgba)\tActive border with opacity")
	fmt.Fprintln(w, "colors.accent_rgb\tstring (rgb)\tHyprlock borders")
	fmt.Fprintln(w, "colors.inactive_border_rgba\tstring (rgba)\tInactive window border")
	fmt.Fprintln(w, "colors.yellow_rgb\tstring (rgb)\tAuxiliary highlight color")
	fmt.Fprintln(w, "colors.red\tstring (hex)\tShell/prompt red")
	fmt.Fprintln(w, "colors.green\tstring (hex)\tShell/prompt green")
	fmt.Fprintln(w, "colors.yellow\tstring (hex)\tShell/prompt yellow")
	fmt.Fprintln(w, "colors.blue\tstring (hex)\tShell/prompt blue")
	fmt.Fprintln(w, "colors.magenta\tstring (hex)\tShell/prompt magenta")
	fmt.Fprintln(w, "colors.cyan\tstring (hex)\tShell/prompt cyan")
	fmt.Fprintln(w, "colors.gray\tstring (hex)\tShell/prompt gray")
	fmt.Fprintln(w, "colors.light_blue\tstring (hex)\tShell/prompt directory")
	fmt.Fprintln(w, "fonts.sans\tstring\tSans-Serif font name")
	fmt.Fprintln(w, "fonts.serif\tstring\tSerif font name")
	fmt.Fprintln(w, "fonts.mono\tstring\tMonospace/Terminal font name")
	fmt.Fprintln(w, "fonts.sizes.gtk\tint\tGTK UI font size")
	fmt.Fprintln(w, "fonts.sizes.kitty\tint\tKitty terminal font size")
	fmt.Fprintln(w, "fonts.sizes.mako\tint\tNotification font size")
	fmt.Fprintln(w, "opacity.kitty\tstring\tKitty opacity (e.g. 0.8)")
	fmt.Fprintln(w, "neovim.colorscheme\tstring\tNeovim theme")
	fmt.Fprintln(w, "neovim.transparent\tbool\tEnable transparent editor")
	w.Flush()
	fmt.Println()
}

func runHomeManagerSwitch(username, nixdotsDir string) {
	fmt.Printf("%sRebuilding user configuration via Home Manager...%s\n", Yellow, Reset)

	targetArg := fmt.Sprintf("%s@horizon", username)
	cmd := exec.Command("home-manager", "switch", "--flake", fmt.Sprintf("%s/#%s", nixdotsDir, targetArg))
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		fmt.Printf("\n%sRebuild failed: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("\n%sConfiguration rebuilt and applied successfully!%s\n", Green, Reset)
}

// ==========================================
// SECRETS MANAGEMENT NAMESPACE
// ==========================================

func handleSecret() {
	if len(os.Args) < 3 {
		printSecretUsage()
		os.Exit(1)
	}

	sub := os.Args[2]
	switch sub {
	case "list", "ls":
		handleSecretList()
	case "lock":
		if len(os.Args) < 5 {
			fmt.Printf("%sError: missing local-path or secret-name.%s\nUsage: theme secret lock <local-path> <secret-name>\n", Red, Reset)
			os.Exit(1)
		}
		handleSecretLock(os.Args[3], os.Args[4])
	case "unlock":
		handleSecretUnlock()
	case "add-ssh":
		handleSecretAddSSH()
	case "add-gpg":
		if len(os.Args) < 4 {
			fmt.Printf("%sError: missing GPG key ID.%s\nUsage: theme secret add-gpg <key-id>\n", Red, Reset)
			os.Exit(1)
		}
		handleSecretAddGPG(os.Args[3])
	case "add-gh":
		handleSecretAddGH()
	case "help", "-h", "--help":
		printSecretUsage()
	default:
		fmt.Printf("%sUnknown secret command: %s%s\n", Red, sub, Reset)
		printSecretUsage()
		os.Exit(1)
	}
}

func printSecretUsage() {
	fmt.Printf("%s%sTheme Secret Manager%s\n", Bold, Cyan, Reset)
	fmt.Println("Securely encrypt and decrypt user-specific credentials in the repository.")
	fmt.Println()
	fmt.Printf("%sUsage:%s\n", Bold, Reset)
	fmt.Println("  theme secret <command> [arguments]")
	fmt.Println()
	fmt.Printf("%sCommands:%s\n", Bold, Reset)
	fmt.Printf("  %slist / ls%s                   List all encrypted secrets for the current user\n", Green, Reset)
	fmt.Printf("  %slock <path> <name>%s          Encrypt a local file and save to repository\n", Green, Reset)
	fmt.Printf("  %sunlock%s                      Decrypt all secrets and restore/import them locally\n", Green, Reset)
	fmt.Printf("  %sadd-ssh%s                     Encrypt current SSH keys (id_ed25519) into the repo\n", Green, Reset)
	fmt.Printf("  %sadd-gpg <key-id>%s            Export and encrypt GPG keys into the repo\n", Green, Reset)
	fmt.Printf("  %sadd-gh%s                      Encrypt GitHub CLI hosts.yml into the repo\n", Green, Reset)
}

func readPasswordPrompt(prompt string) (string, error) {
	fmt.Print(prompt)
	cmd := exec.Command("stty", "-echo")
	cmd.Stdin = os.Stdin
	_ = cmd.Run()

	reader := bufio.NewReader(os.Stdin)
	text, err := reader.ReadString('\n')

	cmdEcho := exec.Command("stty", "echo")
	cmdEcho.Stdin = os.Stdin
	_ = cmdEcho.Run()
	fmt.Println()

	if err != nil {
		return "", err
	}

	return strings.TrimSpace(text), nil
}

func encryptAES(plaintext []byte, passphrase string) ([]byte, error) {
	key := sha256.Sum256([]byte(passphrase))
	block, err := aes.NewCipher(key[:])
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return nil, err
	}

	ciphertext := gcm.Seal(nonce, nonce, plaintext, nil)
	return ciphertext, nil
}

func decryptAES(ciphertext []byte, passphrase string) ([]byte, error) {
	key := sha256.Sum256([]byte(passphrase))
	block, err := aes.NewCipher(key[:])
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonceSize := gcm.NonceSize()
	if len(ciphertext) < nonceSize {
		return nil, fmt.Errorf("ciphertext too short")
	}

	nonce, actualCiphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	plaintext, err := gcm.Open(nil, nonce, actualCiphertext, nil)
	if err != nil {
		return nil, err
	}

	return plaintext, nil
}

func handleSecretList() {
	username, nixdotsDir, _, _ := getPaths()
	secretsDir := filepath.Join(nixdotsDir, ".secrets", username)

	if _, err := os.Stat(secretsDir); os.IsNotExist(err) {
		fmt.Printf("%sNo secrets directory found at %s. Store secrets first.%s\n", Yellow, secretsDir, Reset)
		return
	}

	files, err := ioutil.ReadDir(secretsDir)
	if err != nil {
		fmt.Printf("%sError reading secrets directory: %v%s\n", Red, err, Reset)
		return
	}

	fmt.Printf("\nEncrypted Secrets in Repo (User: %s%s%s):\n\n", Bold, username, Reset)
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 3, ' ', 0)
	fmt.Fprintf(w, "%sSECRET NAME\tFILE SIZE (BYTES)\tSTATUS%s\n", Bold, Reset)

	for _, file := range files {
		if !file.IsDir() && strings.HasSuffix(file.Name(), ".enc") {
			name := strings.TrimSuffix(file.Name(), ".enc")
			fmt.Fprintf(w, "%s\t%d\t%sEncrypted%s\n", name, file.Size(), Gray, Reset)
		}
	}
	w.Flush()
	fmt.Println()
}

func handleSecretLock(localPath string, secretName string) {
	username, nixdotsDir, _, _ := getPaths()

	if strings.HasPrefix(localPath, "~") {
		usr, _ := user.Current()
		localPath = filepath.Join(usr.HomeDir, localPath[1:])
	}

	data, err := ioutil.ReadFile(localPath)
	if err != nil {
		fmt.Printf("%sError reading local file %s: %v%s\n", Red, localPath, err, Reset)
		os.Exit(1)
	}

	passphrase, err := readPasswordPrompt("Enter encryption passphrase: ")
	if err != nil || passphrase == "" {
		fmt.Printf("%sError: passphrase cannot be empty.%s\n", Red, Reset)
		os.Exit(1)
	}

	ciphertext, err := encryptAES(data, passphrase)
	if err != nil {
		fmt.Printf("%sEncryption failed: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	secretsDir := filepath.Join(nixdotsDir, ".secrets", username)
	_ = os.MkdirAll(secretsDir, 0700)

	encFile := filepath.Join(secretsDir, fmt.Sprintf("%s.enc", secretName))
	err = ioutil.WriteFile(encFile, ciphertext, 0600)
	if err != nil {
		fmt.Printf("%sError writing encrypted secret: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("%sSuccessfully encrypted and saved secret '%s' to %s.%s\n", Green, secretName, encFile, Reset)
}

func handleSecretUnlock() {
	username, nixdotsDir, _, _ := getPaths()
	secretsDir := filepath.Join(nixdotsDir, ".secrets", username)

	if _, err := os.Stat(secretsDir); os.IsNotExist(err) {
		fmt.Printf("%sNo secrets found for user '%s' under .secrets/ directory.%s\n", Yellow, username, Reset)
		return
	}

	files, err := ioutil.ReadDir(secretsDir)
	if err != nil {
		fmt.Printf("%sError reading secrets: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	passphrase, err := readPasswordPrompt("Enter decryption passphrase: ")
	if err != nil || passphrase == "" {
		fmt.Printf("%sError: passphrase cannot be empty.%s\n", Red, Reset)
		os.Exit(1)
	}

	usr, _ := user.Current()
	homeDir := usr.HomeDir

	decryptedCount := 0

	for _, file := range files {
		if file.IsDir() || !strings.HasSuffix(file.Name(), ".enc") {
			continue
		}

		filePath := filepath.Join(secretsDir, file.Name())
		ciphertext, err := ioutil.ReadFile(filePath)
		if err != nil {
			fmt.Printf("%sError reading %s: %v%s\n", Red, file.Name(), err, Reset)
			continue
		}

		plaintext, err := decryptAES(ciphertext, passphrase)
		if err != nil {
			fmt.Printf("%sDecryption failed for %s (check passphrase).%s\n", Red, file.Name(), Reset)
			os.Exit(1)
		}

		secretName := strings.TrimSuffix(file.Name(), ".enc")
		targetPath := ""
		isGPG := false

		switch secretName {
		case "ssh_id_ed25519":
			targetPath = filepath.Join(homeDir, ".ssh", "id_ed25519")
			_ = os.MkdirAll(filepath.Dir(targetPath), 0700)
			_ = os.Remove(targetPath)
			err = ioutil.WriteFile(targetPath, plaintext, 0600)
		case "ssh_id_ed25519_pub":
			targetPath = filepath.Join(homeDir, ".ssh", "id_ed25519.pub")
			_ = os.MkdirAll(filepath.Dir(targetPath), 0700)
			_ = os.Remove(targetPath)
			err = ioutil.WriteFile(targetPath, plaintext, 0644)
		case "gh_hosts":
			targetPath = filepath.Join(homeDir, ".config", "gh", "hosts.yml")
			_ = os.MkdirAll(filepath.Dir(targetPath), 0700)
			_ = os.Remove(targetPath)
			err = ioutil.WriteFile(targetPath, plaintext, 0600)
		case "gpg_private":
			isGPG = true
			err = importGPGKey(plaintext, true)
		case "gpg_public":
			isGPG = true
			err = importGPGKey(plaintext, false)
		default:
			targetPath = filepath.Join(homeDir, ".secrets-decrypted", secretName)
			_ = os.MkdirAll(filepath.Dir(targetPath), 0700)
			_ = os.Remove(targetPath)
			err = ioutil.WriteFile(targetPath, plaintext, 0600)
		}

		if err != nil {
			fmt.Printf("%sFailed to restore/import %s: %v%s\n", Red, secretName, err, Reset)
		} else {
			if isGPG {
				fmt.Printf("%sImported GPG key: %s%s\n", Green, secretName, Reset)
			} else {
				fmt.Printf("%sRestored secret: %s -> %s%s\n", Green, secretName, targetPath, Reset)
			}
			decryptedCount++
		}
	}

	fmt.Printf("\n%sSuccessfully decrypted and restored %d secrets.%s\n", Green, decryptedCount, Reset)
}

func importGPGKey(keyData []byte, isPrivate bool) error {
	tmpFile, err := ioutil.TempFile("", "gpg-key-*.asc")
	if err != nil {
		return err
	}
	defer os.Remove(tmpFile.Name())

	if _, err := tmpFile.Write(keyData); err != nil {
		return err
	}
	_ = tmpFile.Close()

	cmd := exec.Command("gpg", "--import", tmpFile.Name())
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func handleSecretAddSSH() {
	usr, _ := user.Current()
	homeDir := usr.HomeDir

	privPath := filepath.Join(homeDir, ".ssh", "id_ed25519")
	pubPath := filepath.Join(homeDir, ".ssh", "id_ed25519.pub")

	if _, err := os.Stat(privPath); os.IsNotExist(err) {
		fmt.Printf("%sError: SSH private key not found at %s. Generate it first.%s\n", Red, privPath, Reset)
		return
	}

	fmt.Println("Encrypting SSH keys...")
	handleSecretLock(privPath, "ssh_id_ed25519")

	if _, err := os.Stat(pubPath); err == nil {
		handleSecretLock(pubPath, "ssh_id_ed25519_pub")
	}
}

func handleSecretAddGPG(keyID string) {
	fmt.Printf("Exporting and encrypting GPG key %s...\n", keyID)

	cmdPriv := exec.Command("gpg", "--armor", "--export-secret-keys", keyID)
	privData, err := cmdPriv.Output()
	if err != nil {
		fmt.Printf("%sError exporting GPG private key: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	cmdPub := exec.Command("gpg", "--armor", "--export", keyID)
	pubData, err := cmdPub.Output()
	if err != nil {
		fmt.Printf("%sError exporting GPG public key: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	passphrase, err := readPasswordPrompt("Enter encryption passphrase: ")
	if err != nil || passphrase == "" {
		fmt.Printf("%sError: passphrase cannot be empty.%s\n", Red, Reset)
		os.Exit(1)
	}

	cipherPriv, err := encryptAES(privData, passphrase)
	if err != nil {
		fmt.Printf("%sEncryption failed for GPG private key: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	cipherPub, err := encryptAES(pubData, passphrase)
	if err != nil {
		fmt.Printf("%sEncryption failed for GPG public key: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	username, nixdotsDir, _, _ := getPaths()
	secretsDir := filepath.Join(nixdotsDir, ".secrets", username)
	_ = os.MkdirAll(secretsDir, 0700)

	err = ioutil.WriteFile(filepath.Join(secretsDir, "gpg_private.enc"), cipherPriv, 0600)
	if err != nil {
		fmt.Printf("%sError writing gpg_private.enc: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	err = ioutil.WriteFile(filepath.Join(secretsDir, "gpg_public.enc"), cipherPub, 0600)
	if err != nil {
		fmt.Printf("%sError writing gpg_public.enc: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}

	fmt.Printf("%sSuccessfully exported, encrypted, and saved GPG key %s.%s\n", Green, keyID, Reset)
}

func handleSecretAddGH() {
	usr, _ := user.Current()
	ghPath := filepath.Join(usr.HomeDir, ".config", "gh", "hosts.yml")

	if _, err := os.Stat(ghPath); os.IsNotExist(err) {
		fmt.Printf("%sError: GitHub CLI config not found at %s. Please authenticate via 'gh auth login' first.%s\n", Red, ghPath, Reset)
		return
	}

	fmt.Println("Encrypting GitHub CLI hosts.yml...")
	handleSecretLock(ghPath, "gh_hosts")
}
