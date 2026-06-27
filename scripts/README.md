# System Management Scripts & TUI Control Panel (`scripts/`)

This directory houses helper and maintenance utility scripts utilized to configure the system, bootstrap credentials, verify hardware profiles, and manage Secure Boot status.

## Component Details

- **[bootstrap-secrets.py](file:///home/conart/nixdots/scripts/bootstrap-secrets.py)**:
  - An interactive Python-based Terminal User Interface (TUI) Control Panel.
  - Implements a dashboard of options:
    1. **🔐 Bootstrap Secrets & Keys**: Generates/restores age master recovery keys, SSH keys, prompts for GitHub PATs, registers SSH keys with GitHub, and encrypts secrets dynamically for `agenix`.
    2. **💻 Hardware & GPU Status**: Automatically detects laptop manufacturer/model and checks dual-GPU configurations (including ASUS MUX mode warnings).
    3. **🛡️ Secure Boot / sbctl Manager**: Queries system Secure Boot status and prompts the user to enroll standard Microsoft keys if UEFI is in Setup Mode.
  - Portable across any NixOS environment by utilizing a standard `nix-shell` shebang at the top, downloading necessary dependencies (such as the `rich` UI library) on-demand.
- **[test_bootstrap_secrets.py](file:///home/conart/nixdots/scripts/test_bootstrap_secrets.py)**:
  - Unit test suite using `pytest` to verify the execution flow of the control panel logic under different hardware configurations and Secure Boot states.

## Running the Control Panel

Ensure the script is executable and launch it:
```bash
./scripts/bootstrap-secrets.py
```
To run the bootstrapper directly and bypass the TUI dashboard, run with the `--bootstrap` flag:
```bash
./scripts/bootstrap-secrets.py --bootstrap
```

## Running the Test Suite

To run the unit tests, invoke `pytest` through a nix shell:
```bash
nix shell nixpkgs#python3Packages.pytest -c pytest scripts/test_bootstrap_secrets.py
```
