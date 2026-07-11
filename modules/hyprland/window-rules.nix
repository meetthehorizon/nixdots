{lib, ...}: let
  makeLuaCode = map (args: {
    _args =
      map (
        arg:
          if builtins.isAttrs arg
          then arg
          else lib.generators.mkLuaInline arg
      )
      args;
  });
in {
  wayland.windowManager.hyprland.settings.layer_rule = {
    match = {
      namespace = "quickshell";
    };
    blur = true;
  };
}
