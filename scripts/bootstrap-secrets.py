#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: [ ps.rich ])"

import os
import sys
import re
import shutil
import subprocess
from pathlib import Path
from datetime import date

# Import rich components
try:
    from rich.console import Console
    from rich.panel import Panel
    from rich.prompt import Prompt, Confirm
    from rich.text import Text
    from rich.table import Table
    from rich import box
except ImportError:
    # Fallback to standard input/print if Rich isn't available
    class FallbackConsole:
        def print(self, *args, **kwargs):
            # Strip simple rich formatting tags
            if args and isinstance(args[0], str):
                msg = re.sub(r'\[/?\w+\s*.*?\]', '', args[0])
                print(msg, *args[1:], **kwargs)
            else:
                print(*args, **kwargs)
    Console = FallbackConsole
    class Prompt:
        @staticmethod
        def ask(prompt_text, choices=None, default=None):
            val = input(f"{prompt_text} {f'({list(choices)})' if choices else ''} [default: {default}]: ")
            return val.strip() or default
    class Confirm:
        @staticmethod
        def ask(prompt_text, default=True):
            val = input(f"{prompt_text} (y/n) [default: {'y' if default else 'n'}]: ")
            if not val:
                return default
            return val.lower().startswith('y')

console = Console()

DOTFILES_DIR = Path(__file__).resolve().parent.parent
SECRETS_DIR = DOTFILES_DIR / "secrets"
BOOTSTRAP_SECRETS_DIR = DOTFILES_DIR / ".secrets"
AGE_KEY_DIR = Path.home() / ".config" / "sops" / "age"
AGE_KEY_FILE = AGE_KEY_DIR / "keys.txt"

def run_cmd(cmd, env=None, capture_output=True, check=True):
    """Helper to run shell commands via subprocess."""
    try:
        res = subprocess.run(
            cmd,
            env=env or os.environ,
            shell=True,
            check=check,
            capture_output=capture_output,
            text=True
        )
        return res.stdout.strip() if res.stdout else ""
    except subprocess.CalledProcessError as e:
        error_msg = e.stderr.strip() if e.stderr else str(e)
        raise RuntimeError(f"Command '{cmd}' failed: {error_msg}")

def read_sysfs(path_str):
    path = Path(path_str)
    if path.exists():
        try:
            return path.read_text().strip()
        except Exception:
            pass
    return ""

def detect_hardware():
    """Detects system vendor, product, and GPU setup."""
    vendor = read_sysfs("/sys/class/dmi/id/sys_vendor")
    product = read_sysfs("/sys/class/dmi/id/product_name")
    
    # Detect GPUs
    gpus = []
    drm_path = Path("/sys/class/drm")
    if drm_path.exists():
        try:
            cards = [p for p in os.listdir(drm_path) if re.match(r'^card\d+$', p)]
            # Check lspci for names if available
            if shutil.which("lspci"):
                lspci_out = run_cmd("lspci | grep -iE 'vga|3d|display'")
                for line in lspci_out.splitlines():
                    if line:
                        # Extract GPU name
                        match = re.search(r'controller:\s*(.*)', line, re.IGNORECASE)
                        if match:
                            gpus.append(match.group(1).strip())
                        else:
                            parts = line.split(': ', 1)
                            if len(parts) > 1:
                                gpus.append(parts[1].strip())
            else:
                gpus = [f"Generic Card {card.replace('card', '')}" for card in cards]
        except Exception:
            pass

    return {
        "vendor": vendor,
        "product": product,
        "gpus": gpus,
        "is_asus": "asus" in vendor.lower()
    }

def print_hardware_status(interactive=True):
    """Renders Hardware & GPU status panel."""
    info = detect_hardware()
    
    text = Text()
    text.append("💻 System Information\n", style="bold cyan")
    text.append(f"  • Vendor:   {info['vendor'] or 'Unknown'}\n")
    text.append(f"  • Model:    {info['product'] or 'Unknown'}\n\n")
    
    text.append("🎮 GPU Configurations\n", style="bold cyan")
    if info['gpus']:
        for i, gpu in enumerate(info['gpus']):
            text.append(f"  • GPU {i}:    {gpu}\n")
        text.append(f"  • Setup:    {'Dual GPU detected' if len(info['gpus']) >= 2 else 'Single GPU'}\n\n")
    else:
        text.append("  • No active GPUs detected via sysfs/lspci.\n\n")
        
    if info['is_asus']:
        text.append("🔧 ASUS Laptop Features Detected\n", style="bold magenta")
        # Check GPU MUX
        mux_val = read_sysfs("/sys/devices/platform/asus-nb-wmi/gpu_mux_mode")
        if mux_val:
            if mux_val == "1":
                text.append("  • GPU MUX:  ✓ Hybrid Mode (Correct)\n", style="bold green")
            else:
                text.append(f"  • GPU MUX:  ⚠️ {mux_val} (Discrete/Dedicated Mode)\n", style="bold yellow")
                text.append("\n[yellow]Recommendation:[/yellow]\n")
                text.append("For this Asus Zephyrus configuration, it is highly recommended to run in Hybrid mode (1).\n")
                text.append("This allows Hyprland to run on the AMD iGPU, offloading to NVIDIA dGPU only on demand.\n")
                text.append("To switch to Hybrid mode, please run:\n")
                text.append("  [bold blue]asusctl armoury set gpu_mux_mode 1[/bold blue]\n")
                text.append("Note: Changing the MUX mode requires a system reboot.\n")
        else:
            text.append("  • GPU MUX:  Not supported or sysfs node not present.\n")
    
    console.print(Panel(text, title="Hardware & GPU Status", border_style="cyan", box=box.ROUNDED))
    if interactive:
        Prompt.ask("\nPress Enter to return to main menu")

def check_secure_boot_status():
    """Runs sbctl status and parses parameters."""
    installed = False
    setup_mode = False
    secure_boot = False
    raw_status = ""
    
    if shutil.which("sbctl"):
        installed = True
        try:
            raw_status = run_cmd("sbctl status")
            # Parse lines
            for line in raw_status.splitlines():
                if "Setup Mode:" in line:
                    setup_mode = "Enabled" in line
                if "Secure Boot:" in line:
                    secure_boot = "Enabled" in line
        except Exception:
            pass
            
    return {
        "installed": installed,
        "setup_mode": setup_mode,
        "secure_boot": secure_boot,
        "raw_status": raw_status
    }

def print_secure_boot_status(interactive=True):
    """Renders Secure Boot status panel and manages enrollment."""
    status = check_secure_boot_status()
    
    text = Text()
    text.append("🛡️ Secure Boot (sbctl) Status\n", style="bold green")
    if not status['installed']:
        text.append("  • status:   ✗ sbctl is not installed on this system.\n", style="bold red")
        console.print(Panel(text, title="Secure Boot Status", border_style="red", box=box.ROUNDED))
        if interactive:
            Prompt.ask("\nPress Enter to return to main menu")
        return
        
    text.append(f"  • Setup Mode:  {'⚠️ Enabled (Keys not enrolled)' if status['setup_mode'] else '✓ Disabled (Keys enrolled)'}\n", 
                style="bold yellow" if status['setup_mode'] else "bold green")
    text.append(f"  • Secure Boot: {'✓ Enabled' if status['secure_boot'] else '✗ Disabled'}\n\n", 
                style="bold green" if status['secure_boot'] else "bold red")
    
    if status['raw_status']:
        text.append("Raw sbctl Output:\n", style="bold cyan")
        for line in status['raw_status'].splitlines():
            text.append(f"  {line}\n")
            
    console.print(Panel(text, title="Secure Boot Status", border_style="green", box=box.ROUNDED))
    
    # Interactive Enrollment
    if status['setup_mode']:
        console.print("\n[bold yellow]System is in UEFI Secure Boot Setup Mode![/bold yellow]")
        enroll = Confirm.ask("Would you like to enroll standard system keys now?")
        if enroll:
            if os.geteuid() != 0:
                console.print("\n[bold red]Error: Enrolling keys requires administrative privileges.[/bold red]")
                console.print("Please execute the enrollment command manually:")
                console.print("  [bold blue]sudo sbctl enroll-keys --microsoft[/bold blue]\n")
            else:
                try:
                    console.print("[cyan]Enrolling keys via sbctl...[/cyan]")
                    run_cmd("sbctl enroll-keys --microsoft")
                    console.print("[bold green]✓ Keys successfully enrolled![/bold green]")
                except Exception as e:
                    console.print(f"[bold red]Failed to enroll keys: {e}[/bold red]")
                    
    if interactive:
        Prompt.ask("\nPress Enter to return to main menu")

def bootstrap_secrets_wizard():
    """Performs full secrets bootstrapping workflow."""
    console.print(Panel("[bold green]🔐 Starting Secrets Bootstrapper[/bold green]\n"
                        "This wizard generates recovery age keys, sets up GitHub SSH keys, "
                        "configures GitHub PAT tokens, and encrypts credentials for NixOS.", 
                        border_style="green", box=box.ROUNDED))
                        
    # 1. Age Key Setup
    AGE_KEY_DIR.mkdir(parents=True, exist_ok=True)
    
    user_age_pub = ""
    if not AGE_KEY_FILE.exists():
        restore_key = Confirm.ask("Do you have an existing age master key to restore?")
        if restore_key:
            key_input = Prompt.ask("Please paste your age private key (AGE-SECRET-KEY-1...)")
            match = re.search(r'AGE-SECRET-KEY-1[A-Za-z0-9]+', key_input)
            if not match:
                console.print("[bold red]ERROR: Invalid age private key format.[/bold red]")
                return
            
            raw_key = match.group(0).strip()
            # Write key to temp file to generate public key
            AGE_KEY_FILE.write_text(raw_key + "\n")
            
            try:
                user_age_pub = run_cmd(f"nix shell nixpkgs#age -c age-keygen -y {AGE_KEY_FILE}")
                # Write standard file
                AGE_KEY_FILE.write_text(f"# public key: {user_age_pub}\n{raw_key}\n")
                AGE_KEY_FILE.chmod(0o600)
                console.print("[bold green]✓ Age key successfully restored in standard format.[/bold green]")
            except Exception as e:
                console.print(f"[bold red]ERROR generating public key: {e}[/bold red]")
                if AGE_KEY_FILE.exists():
                    AGE_KEY_FILE.unlink()
                return
        else:
            console.print("[cyan]Generating new age master recovery key...[/cyan]")
            try:
                run_cmd(f"nix shell nixpkgs#age -c age-keygen -o {AGE_KEY_FILE}")
                user_age_pub = run_cmd(f"nix shell nixpkgs#age -c age-keygen -y {AGE_KEY_FILE}")
                console.print(f"[bold green]✓ Age key generated at {AGE_KEY_FILE}[/bold green]")
                console.print("[bold magenta]󰀼 IMPORTANT: Please backup this key file safely! It is your recovery key.[/bold magenta]")
            except Exception as e:
                console.print(f"[bold red]ERROR: Failed to generate age key: {e}[/bold red]")
                return
    else:
        console.print(f"[green]✓ Found existing age key at {AGE_KEY_FILE}[/green]")
        user_age_pub = run_cmd(f"nix shell nixpkgs#age -c age-keygen -y {AGE_KEY_FILE}")
        
    console.print(f"User age public key: [bold green]{user_age_pub}[/bold green]\n")
    
    # 2. System Host Key
    system_host_pub = ""
    host_pub_path = Path("/etc/ssh/ssh_host_ed25519_key.pub")
    if host_pub_path.exists():
        try:
            system_host_pub = host_pub_path.read_text().strip()
            console.print("[green]✓ Found system host SSH public key.[/green]")
        except Exception:
            pass
    else:
        console.print("[yellow]⚠️ Warning: System host SSH key not found. Secrets will only be decrypted with your age master key.[/yellow]")

    # 3. User SSH Key
    BOOTSTRAP_SECRETS_DIR.mkdir(parents=True, exist_ok=True)
    user_ssh_key = BOOTSTRAP_SECRETS_DIR / "id_ed25519"
    user_ssh_pub_file = BOOTSTRAP_SECRETS_DIR / "id_ed25519.pub"
    
    if not user_ssh_key.exists():
        restore_ssh = Confirm.ask("Do you have an existing SSH private key to restore?")
        if restore_ssh:
            console.print("[cyan]Please paste your SSH private key (Press Enter, then Ctrl+D when finished):[/cyan]")
            lines = []
            try:
                while True:
                    line = input()
                    lines.append(line)
            except EOFError:
                pass
            
            private_content = "\n".join(lines).strip()
            user_ssh_key.write_text(private_content + "\n")
            user_ssh_key.chmod(0o600)
            
            pub_content = Prompt.ask("Please paste your SSH public key (starts with ssh-ed25519)")
            user_ssh_pub_file.write_text(pub_content.strip() + "\n")
            console.print("[bold green]✓ SSH key successfully restored.[/bold green]")
        else:
            console.print("[cyan]Generating new SSH key pair for GitHub...[/cyan]")
            try:
                run_cmd(f'ssh-keygen -t ed25519 -C "kshitij.dev@proton.me" -f {user_ssh_key} -N ""')
                console.print("[bold green]✓ New SSH key pair generated.[/bold green]")
            except Exception as e:
                console.print(f"[bold red]ERROR generating SSH key: {e}[/bold red]")
                return
    else:
        console.print(f"[green]✓ Found existing SSH key at {user_ssh_key}[/green]")
        
    # 4. GitHub PAT Lookup
    user_pat_file = BOOTSTRAP_SECRETS_DIR / "github-pat"
    github_pat = ""
    
    if user_pat_file.exists():
        github_pat = user_pat_file.read_text().strip()
    elif os.environ.get("GITHUB_PAT"):
        github_pat = os.environ.get("GITHUB_PAT")
    elif os.environ.get("GH_TOKEN"):
        github_pat = os.environ.get("GH_TOKEN")
    else:
        # Check local gh
        if shutil.which("gh"):
            try:
                github_pat = run_cmd("gh auth token")
            except Exception:
                pass
        # Fallback to nix-shell gh
        if not github_pat:
            try:
                github_pat = run_cmd("nix shell nixpkgs#gh -c gh auth token")
            except Exception:
                pass
                
    if not github_pat:
        restore_pat = Confirm.ask("Do you have a GitHub Personal Access Token (PAT) to configure?")
        if restore_pat:
            github_pat = Prompt.ask("Please paste your GitHub Classic PAT (ghp_...)").strip()
        else:
            console.print("[bold red]ERROR: GitHub PAT/credentials not found. Exiting bootstrapper.[/bold red]")
            return
            
    user_pat_file.write_text(github_pat + "\n")
    user_pat_file.chmod(0o600)
    console.print("[bold green]✓ GitHub PAT configured.[/bold green]")
    
    # 5. Register SSH Key on GitHub
    if user_ssh_pub_file.exists():
        ssh_pub_body = user_ssh_pub_file.read_text().strip().split()[1]
        console.print("[cyan]Checking if SSH key is registered with GitHub...[/cyan]")
        try:
            gh_env = os.environ.copy()
            gh_env["GH_TOKEN"] = github_pat
            
            registered_keys = run_cmd("nix shell nixpkgs#gh -c gh ssh-key list", env=gh_env)
            if ssh_pub_body in registered_keys:
                console.print("[green]✓ SSH key is already registered with GitHub.[/green]")
            else:
                console.print("[cyan]SSH key not found on GitHub. Registering it...[/cyan]")
                key_title = f"NixOS - {os.uname().nodename} - {date.today()}"
                run_cmd(f"nix shell nixpkgs#gh -c gh ssh-key add {user_ssh_pub_file} --title '{key_title}'", env=gh_env)
                console.print("[bold green]✓ SSH key successfully registered with GitHub.[/bold green]")
        except Exception as e:
            console.print(f"[yellow]⚠️ Warning: Failed to automatically register SSH key with GitHub: {e}[/yellow]")
            
    # 6. Create secrets.nix
    SECRETS_DIR.mkdir(parents=True, exist_ok=True)
    secrets_nix = SECRETS_DIR / "secrets.nix"
    
    console.print(f"[cyan]Creating {secrets_nix}...[/cyan]")
    secrets_content = f"""# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "{user_age_pub}";
  hostKey = "{system_host_pub}";
  keys = if hostKey != "" then [ userKey hostKey ] else [ userKey ];
in
{{
  "github-ssh-key.age".publicKeys = keys;
  "github-pat.age".publicKeys = keys;
}}
"""
    secrets_nix.write_text(secrets_content)
    
    # 7. Encrypt secrets
    console.print("[cyan]Encrypting secrets...[/cyan]")
    age_args = ["-r", user_age_pub]
    if system_host_pub:
        age_args.extend(["-r", system_host_pub])
        
    age_args_str = " ".join(f"'-r' '{arg}'" for arg in age_args)
    try:
        run_cmd(f"nix shell nixpkgs#age -c age {age_args_str} -o {SECRETS_DIR}/github-ssh-key.age {user_ssh_key}")
        run_cmd(f"nix shell nixpkgs#age -c age {age_args_str} -o {SECRETS_DIR}/github-pat.age {user_pat_file}")
        console.print("[bold green]✓ Secrets successfully encrypted and stored.[/bold green]")
    except Exception as e:
        console.print(f"[bold red]ERROR encrypting secrets: {e}[/bold red]")
        return
        
    # 8. Local Config Cleanups
    console.print("[cyan]Cleaning up local configs...[/cyan]")
    local_ssh_key = Path.home() / ".ssh" / "id_ed25519"
    local_ssh_pub = Path.home() / ".ssh" / "id_ed25519.pub"
    
    if local_ssh_key.exists() and not local_ssh_key.is_symlink():
        local_ssh_key.unlink()
    if local_ssh_pub.exists() and not local_ssh_pub.is_symlink():
        local_ssh_pub.unlink()
        
    # Temporary ~/.ssh/config setup
    ssh_config_dir = Path.home() / ".ssh"
    ssh_config_dir.mkdir(parents=True, exist_ok=True)
    ssh_config_dir.chmod(0o700)
    ssh_config_file = ssh_config_dir / "config"
    
    github_ssh_block = """
Host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_ed25519
  User git
"""
    if not ssh_config_file.exists():
        ssh_config_file.write_text(github_ssh_block.strip() + "\n")
        ssh_config_file.chmod(0o600)
        console.print("[green]✓ Temporary ~/.ssh/config created.[/green]")
    elif not ssh_config_file.is_symlink():
        content = ssh_config_file.read_text()
        if "Host github.com" not in content:
            ssh_config_file.write_text(content + "\n" + github_ssh_block)
            console.print("[green]✓ Appended github.com settings to ~/.ssh/config.[/green]")
            
    local_gh_pat = Path.home() / ".config" / "gh" / "github-pat"
    if local_gh_pat.exists() and not local_gh_pat.is_symlink():
        local_gh_pat.unlink()
        
    console.print("[bold green]✓ Secrets successfully prepared for NixOS rebuild![/bold green]")
    console.print("You can now commit the 'secrets/' directory to Git.\n")
    
    restart_shell = Confirm.ask("Do you want to restart your shell now?", default=False)
    if restart_shell:
        shell = os.environ.get("SHELL", "/bin/bash")
        console.print(f"[cyan]Restarting shell ({shell})...[/cyan]")
        os.execl(shell, shell)

def main():
    # If run non-interactively via argv or if stdin is not a tty
    if len(sys.argv) > 1 and sys.argv[1] == "--bootstrap":
        # Force non-interactive bootstrap (could fail if files missing, but acts as CLI)
        bootstrap_secrets_wizard()
        sys.exit(0)
        
    # Main menu loop
    while True:
        console.clear()
        menu_text = Text()
        menu_text.append("🛠️ Horizon NixOS Control Panel & Bootstrapper\n", style="bold cyan")
        menu_text.append("--------------------------------------------------\n", style="dim")
        menu_text.append("1. 🔐 Bootstrap Secrets & Keys\n")
        menu_text.append("2. 💻 View Hardware & GPU Status\n")
        menu_text.append("3. 🛡️ Secure Boot / sbctl Manager\n")
        menu_text.append("4. ❌ Exit\n")
        
        console.print(Panel(menu_text, border_style="cyan", box=box.ROUNDED))
        
        choice = Prompt.ask("Choose an option", choices=["1", "2", "3", "4"], default="4")
        
        if choice == "1":
            bootstrap_secrets_wizard()
            Prompt.ask("\nPress Enter to return to main menu")
        elif choice == "2":
            print_hardware_status(interactive=True)
        elif choice == "3":
            print_secure_boot_status(interactive=True)
        elif choice == "4":
            console.print("[cyan]Exiting control panel. Goodbye![/cyan]")
            break

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n[yellow]Interrupted by user. Exiting.[/yellow]")
        sys.exit(0)
