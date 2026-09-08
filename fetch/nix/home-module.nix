{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fetch;

  infoFields = [
    "os"
    "host"
    "kernel"
    "uptime"
    "packages"
    "shell"
    "display"
    "wm"
    "theme"
    "icons"
    "font"
    "terminal"
    "cpu"
    "gpu"
    "memory"
    "swap"
    "disk"
    "ip"
    "battery"
    "locale"
    "colors"
  ];
in
{
  options.programs.fetch = {
    enable = lib.mkEnableOption "fetch";

    info = lib.mkOption {
      type = lib.types.listOf (lib.types.enum infoFields);
      default = infoFields;
      description = "Info fields to display, in order. Add entries to show them.";
    };

    labelColor = lib.mkOption {
      type = lib.types.enum [
        "red"
        "green"
        "yellow"
        "blue"
        "magenta"
        "cyan"
        "white"
      ];
      default = "magenta";
      description = "Color used for info labels.";
    };

    separator = lib.mkOption {
      type = lib.types.str;
      default = "-";
      description = "Character used for the title separator line.";
    };

    shading = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Characters used for 3D shading.";
    };

    light = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "top-left"
          "top-right"
          "top"
          "left"
          "right"
          "front"
          "bottom-left"
          "bottom-right"
        ]
      );
      default = null;
      description = "Light direction for 3D shading.";
    };

    spin = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "x"
          "y"
          "xy"
        ]
      );
      default = null;
      description = "Rotation axis for the 3D animation.";
    };

    speed = lib.mkOption {
      type = lib.types.nullOr lib.types.float;
      default = null;
      description = "Rotation speed.";
    };

    size = lib.mkOption {
      type = lib.types.nullOr lib.types.float;
      default = null;
      description = "Logo scale.";
    };

    height = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Override render height.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra lines.";
    };
  };

  # Generate config file
  config = lib.mkIf cfg.enable {
    home.packages = [ (pkgs.callPackage ./package.nix { }) ];

    xdg.configFile."fetch/config".text =
      let
        fieldLines = cfg.info; # drop key
        settingLines = lib.mapAttrsToList (key: value: "${key}=${value}") (
          lib.filterAttrs (_: value: value != null) {
            # filter empty values
            label_color = cfg.labelColor;
            separator = cfg.separator;
            shading = cfg.shading;
            light = cfg.light;
            spin = cfg.spin;
            speed = if cfg.speed != null then toString cfg.speed else null;
            size = if cfg.size != null then toString cfg.size else null;
            height = if cfg.height != null then toString cfg.height else null;
          }
        );
      in
      lib.concatStringsSep "\n" (fieldLines ++ settingLines) + "\n" + cfg.extraConfig; # extraConfig last to limit user error
  };
}
