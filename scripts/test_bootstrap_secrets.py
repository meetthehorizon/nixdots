import sys
import os
import importlib.util
from pathlib import Path
from unittest.mock import patch, MagicMock

# Dynamically import the module with hyphens
scripts_dir = Path(__file__).resolve().parent
bootstrap_path = scripts_dir / "bootstrap-secrets.py"

spec = importlib.util.spec_from_file_location("bootstrap_secrets", str(bootstrap_path))
bootstrap_secrets = importlib.util.module_from_spec(spec)
sys.modules["bootstrap_secrets"] = bootstrap_secrets
spec.loader.exec_module(bootstrap_secrets)

def test_detect_hardware_non_asus():
    """Test hardware detection on a non-ASUS single GPU machine."""
    with patch("bootstrap_secrets.read_sysfs") as mock_read_sysfs, \
         patch("pathlib.Path.exists") as mock_exists, \
         patch("os.listdir") as mock_listdir, \
         patch("shutil.which", return_value=None):
         
        # Mock sysfs values
        mock_exists.return_value = True
        
        def side_effect_read(path_str):
            if "sys_vendor" in path_str:
                return "Framework"
            if "product_name" in path_str:
                return "Laptop 13"
            return ""
        mock_read_sysfs.side_effect = side_effect_read
        mock_listdir.return_value = ["card0", "renderD128", "version"]
        
        info = bootstrap_secrets.detect_hardware()
        assert info["vendor"] == "Framework"
        assert info["product"] == "Laptop 13"
        assert not info["is_asus"]
        assert len(info["gpus"]) == 1
        assert "Generic Card 0" in info["gpus"][0]

def test_detect_hardware_asus_dual_gpu():
    """Test hardware detection on an ASUS ROG laptop with dual GPUs."""
    with patch("bootstrap_secrets.read_sysfs") as mock_read_sysfs, \
         patch("pathlib.Path.exists") as mock_exists, \
         patch("os.listdir") as mock_listdir, \
         patch("shutil.which", return_value=True), \
         patch("bootstrap_secrets.run_cmd") as mock_run_cmd:
         
        mock_exists.return_value = True
        
        def side_effect_read(path_str):
            if "sys_vendor" in path_str:
                return "ASUSTeK COMPUTER INC."
            if "product_name" in path_str:
                return "ROG Zephyrus G14"
            if "gpu_mux_mode" in path_str:
                return "1"
            return ""
        mock_read_sysfs.side_effect = side_effect_read
        mock_listdir.return_value = ["card0", "card1", "renderD128", "renderD129"]
        
        # Mock lspci output
        mock_run_cmd.return_value = (
            "00:02.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 163f\n"
            "01:00.0 VGA compatible controller: NVIDIA Corporation GA107M [GeForce RTX 3050 Mobile]"
        )
        
        info = bootstrap_secrets.detect_hardware()
        assert info["is_asus"]
        assert info["vendor"] == "ASUSTeK COMPUTER INC."
        assert len(info["gpus"]) == 2
        assert "Advanced Micro Devices" in info["gpus"][0]
        assert "NVIDIA Corporation" in info["gpus"][1]

def test_check_secure_boot_status_installed():
    """Test parsing sbctl status when installed and configured."""
    with patch("shutil.which", return_value="/run/current-system/sw/bin/sbctl"), \
         patch("bootstrap_secrets.run_cmd") as mock_run:
         
        mock_run.return_value = (
            "Installed:      ✓ sbctl is installed\n"
            "Owner GUID:     7edaada3-26a9-43a8-b1a7-0886eddbf35f\n"
            "Setup Mode:     ✗ Disabled\n"
            "Secure Boot:    ✓ Enabled\n"
            "Vendor Keys:    microsoft builtin-db builtin-KEK"
        )
        
        status = bootstrap_secrets.check_secure_boot_status()
        assert status["installed"]
        assert not status["setup_mode"]
        assert status["secure_boot"]

def test_check_secure_boot_status_setup_mode():
    """Test parsing sbctl status when in setup mode."""
    with patch("shutil.which", return_value="/run/current-system/sw/bin/sbctl"), \
         patch("bootstrap_secrets.run_cmd") as mock_run:
         
        mock_run.return_value = (
            "Installed:      ✓ sbctl is installed\n"
            "Owner GUID:     7edaada3-26a9-43a8-b1a7-0886eddbf35f\n"
            "Setup Mode:     ✓ Enabled\n"
            "Secure Boot:    ✗ Disabled\n"
            "Vendor Keys:    none"
        )
        
        status = bootstrap_secrets.check_secure_boot_status()
        assert status["installed"]
        assert status["setup_mode"]
        assert not status["secure_boot"]

def test_check_secure_boot_status_not_installed():
    """Test parsing sbctl status when sbctl is missing."""
    with patch("shutil.which", return_value=None):
        status = bootstrap_secrets.check_secure_boot_status()
        assert not status["installed"]
