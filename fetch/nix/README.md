# Flake & Home-module
## Flake Install
```nix
inputs = {
  ...
  areofyl-fetch.url = "github:areofyl/fetch";
  ...
}
```

## Home-manager
You also need to import the nix package in your ```home.nix```. 

```nix
{ pkgs, inputs, ... }: 

{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];
  
  programs.fetch = {
    enable = true;
    labelColor = "red";
    info = [
      "os"
      "kernel"
      "uptime"
    ];
    speed = 1.0;
    spin = "xy";
  };
  
}
```

# Examples and home-manager options
Here is a default configuration:
```nix
{ pkgs, inputs, ... }: 

{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];
  
  programs.fetch = {
    enable = true;
    labelColor = "red";
    info = [
      "os"
      "host"
      "kernel"
      "uptime"
    ];
    speed = 1.0;
    spin = "xy";
  };
  
}
```

## All options
### info
Options:
  ```"os"
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
  ```

  Ex: ```info = [ "os" "host" "kernel" "uptime" ];```

### labelColor
  Options:
  ```
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
  ```
  Ex: ```labelColor = "blue";```

### separator
  Options:
  ```
    "-"
    ">"
    You can use any single character
  ```
  Ex: ```separator = "";```

### shading
  Options:
  ```
    "mMz"
    ".Mm|"
    "█░.Mm
  ```

  Ex: ```shading = "mMz"; ```

### light
  Options:
  ```
    "top-left"
    "top-right"
    "top"
    "left"
    "right"
    "front"
    "bottom-left"
    "bottom-right"
  ```

  Ex: ```light = "top-left"; ```

### spin
  Options:
  ```
    "xy"
    "x"
    "y"
  ```

  Ex: ```spin = "xy"; ```

### speed
  Options:
  ```
    1.0
    2.0
    3.0
    ...
  ```
  Ex: ```speed = 1.0; ```

### size
  Options:
  ```
    1.0
    2.0
    3.0
    ...
  ```
  Ex: ```size = 1.0; ```

### height
  Options:
  ```
    1.0
    2.0
    3.0
    ...
  ```
  Ex: ```height = 1.0;```

### extraConfig
  Options:
  ```
    "futureOptionFloat = 1.0"
    "futureOptionBool = true"
    "futureOptionStr = "metric"
  ```
  Ex: ```extraConfig = "futureOptionFloat = 1.0"; ```

# Maintenance
Whenever there is a new version release of fetch follow this guide. This is mostly written to my forgetful self.

## Before you begin
### Wrap dependencies
See if there are any new packages which need to be wrapped.
If you're a new Nix maintainer to this repo and understand C you can take a glance at the commits merged since last release. Contributors will inform if a new dependency has been introduced.

### New option in fetch.c
Use this checklist:
- Check type of the value in fetch.c
- Create a new mkOption in home-module.nix
- Write a short description
- Set default value to null to inherit fetch.c defaults
  - Change default value if applicable
- Input new option at the flatfile generator
  - If an attribute does not require a key only a value you have to add it before cfg.ExtraConfig on line 145 and add a new line
- Write a short example in this README when done

### Code changes
Remember to run nixfmt on the code before committing.
