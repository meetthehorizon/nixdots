package main

import (
	"encoding/json"
	"fmt"
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
	fmt.Printf("%sExamples:%s\n", Bold, Reset)
	fmt.Println("  theme list")
	fmt.Println("  theme switch tokyonight")
	fmt.Println("  theme set colors.accent \"#ff0055\"")
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


