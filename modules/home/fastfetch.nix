# Fastfetch configurations
{pkgs, ...}: {
  home.packages = with pkgs; [
    fastfetch
  ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
    logo = {
      source = "nixos";
      type = "builtin";
      color = {
        "1" = "light_yellow";
        "2" = "light_yellow";
        "3" = "light_yellow";
        "4" = "light_yellow";
        "5" = "light_yellow";
        "6" = "light_yellow";
      };
    };
    display = {
      separator = " ";
      color = {
        keys = "light_yellow";
        output = "default";
        title = "yellow";
      };
    };
    modules = [
      {
        type = "title";
      }
      {
        type = "separator";
      }
      {
        type = "os";
        key = "OS";
        keyColor = "light_yellow";
      }
      {
        type = "kernel";
        key = "Kernel";
        keyColor = "light_yellow";
      }
      {
        type = "uptime";
        key = "Uptime";
        keyColor = "light_yellow";
      }
      {
        type = "packages";
        key = "Packages";
        keyColor = "light_yellow";
      }
      {
        type = "shell";
        key = "Shell";
        keyColor = "light_yellow";
      }
      {
        type = "de";
        key = "DE";
        keyColor = "light_yellow";
      }
      {
        type = "wm";
        key = "WM";
        keyColor = "light_yellow";
      }
      {
        type = "wmtheme";
        key = "WM Theme";
        keyColor = "light_yellow";
      }
      {
        type = "terminal";
        key = "Terminal";
        keyColor = "light_yellow";
      }
      {
        type = "terminalfont";
        key = "Terminal Font";
        keyColor = "light_yellow";
      }
      {
        type = "cpu";
        key = "CPU";
        keyColor = "light_yellow";
      }
      {
        type = "gpu";
        key = "GPU";
        keyColor = "light_yellow";
      }
      {
        type = "memory";
        key = "Memory";
        keyColor = "light_yellow";
      }
      {
        type = "disk";
        key = "Disk";
        keyColor = "light_yellow";
      }
      {
        type = "localip";
        key = "Local IP";
        keyColor = "light_yellow";
      }
      {
        type = "colors";
        key = "Colors";
        keyColor = "light_yellow";
      }
    ];
  };

  xdg.configFile."fastfetch/minimal.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
    logo = {
      source = "nixos_small";
      type = "small";
      color = {
        "1" = "light_yellow";
        "2" = "light_yellow";
        "3" = "light_yellow";
        "4" = "light_yellow";
        "5" = "light_yellow";
        "6" = "light_yellow";
      };
      position = "right";
      preserveAspectRatio = "true";
    };
    display = {
      color = {
        keys = "light_yellow";
        output = "default";
        title = "yellow";
      };
      key = {
        width = 12;
      };
    };
    modules = [
      {
        type = "title";
      }
      {
        type = "separator";
      }
      {
        type = "os";
        key = "OS";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "kernel";
        key = "Kernel";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "shell";
        key = "Shell";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "de";
        key = "DE";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "wm";
        key = "WM";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "resolution";
        key = "Resolution";
        keyColor = "light_yellow";
        format = "{width}x{height}";
      }
      {
        type = "terminal";
        key = "Terminal";
        keyColor = "light_yellow";
        format = "{2}";
      }
      {
        type = "cpu";
        key = "CPU";
        keyColor = "light_yellow";
        format = "{name}";
      }
      {
        type = "gpu";
        key = "GPU";
        keyColor = "light_yellow";
        format = "{name}";
      }
      {
        type = "memory";
        key = "Memory";
        keyColor = "light_yellow";
      }
    ];
  };
}
