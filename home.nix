###
#   This file should be placed in ${HOME}/.config/home-manager/home.nix
#   Modifications take effect after running `home-manager switch`
#
#   https://nix-community.github.io/home-manager/options.xhtml
###
{ config, pkgs, lib, ... }:
let
  # Tell nix a little about yourself
  username = "brett";
  homeDirectory = "/home/brett";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05"; # Please read the comment before changing

  # Enable catppuccin theme (requires catppuccin flake input)
  catppuccin = {
    enable = true;
    flavor = "mocha";
    fish.enable = true;
    starship.enable = true;
    lazygit.enable = true;
    k9s.enable = true;
  };

  # Any variables you may want to add
  home.sessionVariables = {
    # Fix for ghostty not working properly
    TERM = "xterm-256color";
    # Update this to your preferred AWS profile
    AWS_PROFILE = "default";
  };

  # Git - with sensible defaults (UPDATE THESE WITH YOUR INFO)
  programs.git = {
    enable = true;
    userName = "Your Name";  # CHANGE THIS
    userEmail = "your.email@example.com";  # CHANGE THIS
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      pull.rebase = false;
      init.defaultBranch = "main";
    };
  };

  # Fish shell with plugins
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    shellAliases = {
      cat = "bat";
      ls = "eza";
      ll = "eza -la";
      la = "eza -la";
    };
    shellAbbrs = {
      lg = "lazygit";
      kc = "kubectx";
      kn = "kubens";
    };
    interactiveShellInit = ''
      function fish_greeting
        fastfetch
      end
      test -f ~/.kubectl_aliases.fish && source ~/.kubectl_aliases.fish
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      azure = {
        disabled = false;
      };
      git_branch = {
        disabled = false;
      };
      git_commit = {
        disabled = false;
      };
      git_state = {
        disabled = false;
      };
      git_status = {
        disabled = false;
      };
      kubernetes = {
        disabled = false;
      };
    };
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    historyLimit = 50000;
    terminal = "tmux-256color";
    keyMode = "vi";
    shortcut = "a";
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      set-option -g status-style bg=default,fg=colour105
      set-option -g status-position top
      set -s set-clipboard on
      
      # Better mouse support
      set -g mouse on
      
      # Vi mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
    '';
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      vim-tmux-navigator
      resurrect
    ];
  };

  # Ghostty terminal (optional, enable if you want to use it)
  programs.ghostty = {
    enable = false;
  };

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # Better ls
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = true;
  };

  # Lazygit
  programs.lazygit = {
    enable = true;
  };

  # Better cat
  programs.bat = {
    enable = true;
    config = {
    };
  };

  # Better find
  programs.fd = {
    enable = true;
  };

  # TUI file managers
  programs.lf = {
    enable = true;
  };

  programs.nnn = {
    enable = true;
  };

  # Better grep
  programs.ripgrep = {
    enable = true;
  };

  # Better top
  programs.btop = {
    enable = true;
  };

  # System info
  programs.fastfetch = {
    enable = true;
  };

  # Fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # File downloads
  home.file.".kubectl_aliases.fish" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ahmetb/kubectl-aliases/refs/heads/master/.kubectl_aliases.fish";
      hash = "sha256-MhwUO6t0os6zwYdi4f4kRq+mGWVOf377I5hND76vr/U=";
    };
  };

  # LazyVim starter config
  home.file.".config/nvim" = {
    source = fetchGit {
      url = "https://github.com/LazyVim/starter";
      ref = "main";
    };
    recursive = true;
  };

  # Package installations
  home.packages = with pkgs; [
    # AI chat
    aichat
    
    # Automation
    ansible
    
    # Nix tools
    nil
    nixpkgs-lint
    nixfmt-classic
    
    # Network tools
    net-snmp
    httpie
    grpcurl
    
    # Kubernetes tools
    stern
    kubectx
    kubectl
    k9s
    
    # Development tools
    cargo
    rustc
    go
    nodejs
    
    # Password management
    gopass
    pinentry-curses
    
    # System tools
    sysz
    watchexec
    stow
    
    # Productivity
    nb
    w3m
    
    # Additional useful tools
    jq
    yq
    tree
    wget
    curl
    unzip
    zip
    git
  ];
}
