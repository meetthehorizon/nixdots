# Assets Directory

This directory contains static system assets such as wallpapers, icons, screenshots, and other user media.

## Contents

- **Pictures/**: Main folder containing categorized images.
  - **wallpapers-pc/**: High-resolution system wallpapers for desktop/laptop displays.
  - **wallpapers-pc-gif/**: Animated wallpapers for the system lockscreen or desktop background.
  - **wallpapers-phone/**: System-themed wallpapers optimized for mobile device displays.
  - **icons/**: Custom desktop and user icons utilized across display and display manager configurations.
  - **Screenshots/**: System screenshots.
  - **Camera Roll/**: Personal captured images.

## Nix Integration

These assets are symlinked or referenced in Nix configurations through [assets.nix](file:///home/conart/nixdots/assets.nix) and utilized in [modules/assets.nix](file:///home/conart/nixdots/modules/assets.nix). For instance, system lockscreen and desktop backgrounds are defined declaratively in the Nix config to pull assets directly from the repository.
