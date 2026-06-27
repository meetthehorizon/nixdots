# System Management Scripts & TUI Control Panel (`scripts/`)

This directory houses helper and maintenance utility scripts utilized to configure the system, bootstrap credentials, verify hardware profiles, and manage Secure Boot status.

## Component Details

- **[nixdots](file:///home/conart/nixdots/scripts/nixdots)**:
  - An interactive Python-based Terminal User Interface (TUI) Control Panel.
  - Implements a dashboard of options:
    1. **🔐 Bootstrap Secrets & Keys**: Generates/restores age master recovery keys, SSH keys, prompts for GitHub PATs, registers SSH keys with GitHub, and encrypts secrets dynamically for `agenix`.
    2. **💻 Hardware & GPU Status**: Automatically detects laptop manufacturer/model and checks dual-GPU configurations (including ASUS MUX mode warnings).
    3. **🛡️ Secure Boot / sbctl Manager**: Queries system Secure Boot status and prompts the user to enroll standard Microsoft keys if UEFI is in Setup Mode.
  - Accessible globally as the command `nixdots` because it is symlinked to `~/.local/bin/nixdots` via Home Manager.
- **[test_nixdots.py](file:///home/conart/nixdots/scripts/test_nixdots.py)**:
  - Unit test suite using `pytest` to verify the execution flow of the control panel logic under different hardware configurations and Secure Boot states.

## Running the Control Panel

Once the system has been built/switched (`nate`), the script is available globally. Simply run:
```bash
nixdots
```
To run the bootstrapper directly and bypass the TUI dashboard, run with the `--bootstrap` flag:
```bash
nixdots --bootstrap
```

## Running the Test Suite

To run the unit tests, invoke `pytest` through a nix shell:
```bash
nix shell nixpkgs#python3Packages.pytest -c pytest scripts/test_nixdots.py
```
