{lib, ...}: let
  mkIntOption = default:
    lib.mkOption {
      type = lib.types.int;
      inherit default;
    };

  mkFloatOption = default:
    lib.mkOption {
      type = lib.types.float;
      inherit default;
    };
in {
  options.ui = {
    effects = {
      surfaceAlpha = mkFloatOption 0.55;
      surfaceVariantAlpha = mkFloatOption 0.85;
      blur = mkIntOption 24;
      borderOpacity = mkFloatOption 0.6;
    };

    shadow = {
      opacity = mkFloatOption 0.15;
      blur = mkIntOption 20;
      offsetX = mkIntOption 0;
      offsetY = mkIntOption 6;
    };

    spacing = {
      s0 = mkIntOption 0;
      s1 = mkIntOption 4;
      s2 = mkIntOption 8;
      s3 = mkIntOption 12;
      s4 = mkIntOption 16;
      s5 = mkIntOption 20;
      s6 = mkIntOption 24;
      s8 = mkIntOption 32;
      s10 = mkIntOption 40;
      s12 = mkIntOption 48;
      s16 = mkIntOption 64;
      s20 = mkIntOption 80;
      s24 = mkIntOption 96;
      s32 = mkIntOption 128;
    };

    radius = {
      r0 = mkIntOption 0;
      r1 = mkIntOption 4;
      r2 = mkIntOption 8;
      r3 = mkIntOption 12;
      r4 = mkIntOption 16;
      r5 = mkIntOption 24;
      r6 = mkIntOption 9999;
    };

    border = {
      none = mkIntOption 0;
      w1 = mkIntOption 1;
      w2 = mkIntOption 2;
      w3 = mkIntOption 3;
      w4 = mkIntOption 4;
    };

    animation = {
      vf = mkIntOption 100;
      f = mkIntOption 200;
      n = mkIntOption 300;
      s = mkIntOption 500;
      vs = mkIntOption 800;
    };
  };
}
