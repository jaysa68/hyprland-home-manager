{ config, pkgs, hyprland-plugins, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jaysa";
  home.homeDirectory = "/home/j/ja/jaysa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jaysa/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.

  gtk.font.size = 32;

  programs = {
    fuzzel = {
      enable = true;
      settings.main.anchor = "bottom-left";
    };
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "bottom";
	  modules-left = [ "custom/launcher" "wlr/taskbar" ];
	  modules-right = [ "tray" ];
	  "wlr/taskbar" = {
	    "format" = "{icon}";
	    "icon-size" = 48;
	    "tootltip-format" = "{title}";
	    "on-click" = "activate";
	    "app_ids-mapping" = {
	      "firefox" = "firefox";
	    };
	  };
	  "custom/launcher" = {
	    "format" = "menu";
	    "icon-size" = 48;
	    "tootltip-format" = "{title}";
	    "on-click" = "fuzzel";
	  };
        };
      };
    };
    git = {
      enable = true;
      userName = "jaysa68";
      userEmail = "gh@jaysa.net";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraConfig = ''
        set background=dark
	colorscheme gruvbox
	set number
      '';
      plugins = with pkgs.vimPlugins; [
        gruvbox
        neo-tree-nvim
        nvim-web-devicons #neotree optional
        nvim-window-picker #neotree optional
        plenary-nvim #neotree dependency
        nui-nvim #neotree dependency
        nvim-treesitter
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.rust
        nvim-treesitter-parsers.python
        nvim-treesitter-parsers.puppet
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.java
        nvim-treesitter-parsers.c
        nvim-treesitter-parsers.markdown
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.html
        nvim-treesitter-parsers.css
      ];
      viAlias = true;
      vimAlias = true;
    };
    starship = {
      enable = true;
    };
    kitty = {
      enable = true;
      enableGitIntegration = true;
      themeFile = "gruvbox-dark-hard";
      font = {
        name = "hack";
        #size = 20.0;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];

    settings = {
      "$mod" = "SUPER";
      general = {
        border_size = 2;
	gaps_in = 5;
        gaps_out = 20;
	"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
	rounding_power = 2;
	active_opacity = 1.0;
	inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      animations = {
        enabled = "yes, please :)";
      };
      misc = {
        disable_hyprland_logo = false;
        force_default_wallpaper = "-1";
      };

      bind = [
      "$mod, Q, exec, kitty"
      "$mod, G, exec, firefox"
      "$mod, C, killactive"
      ];

      plugin.hyprbars = {
        bar_height = 40;
	bar_color = "rgb(000000)";
	bar_text_size = 9;
	bar_buttons_alignment = "right";
	hyprbars-button = "rgb(ebdbb2), 10, , hyprctl dispatch killactive";
      };
    };
  };

}
