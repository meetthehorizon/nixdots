{lib, ...}: let
  mkStrOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in {
  options.color = {
    style = mkStrOption "tokyonight";
    surface = mkStrOption "#1e1e2e";
    surfaceVariant = mkStrOption "#313244";

    text = mkStrOption "#cdd6f4";
    textMuted = mkStrOption "#7f849c";

    border = mkStrOption "#45475a";
    outline = mkStrOption "#89b4fa";

    error = mkStrOption "#f38ba8";
    accent = mkStrOption "#89b4fa";

    terminal = {
      red = mkStrOption "#f7768e";
      green = mkStrOption "#9ece6a";
      yellow = mkStrOption "#e0af68";
      blue = mkStrOption "#7aa2f7";
      magenta = mkStrOption "#bb9af7";
      cyan = mkStrOption "#7dcfff";
      gray = mkStrOption "#565f89";
      black = mkStrOption "#1a1b26";
      white = mkStrOption "#c0caf5";
    };
  };
}
