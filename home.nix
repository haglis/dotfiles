{ config, pkgs, pythonPkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  # Python 3.15's package closure still has compatibility failures in Nixpkgs
  # (including dill and parso). Keep the current 3.14 patch release for now.
  python = pythonPkgs.python314;

in

{
  home.username = "jianhual";
  home.homeDirectory = "/Users/jianhual";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep  # fast search
    fd       # fast find
    fzf      # fuzzy finder
    jq       # json on the command line
    lazygit
    neovim
    tmux
    uv       # Python package and project manager
    # Rust toolchain managed by Nix
    nodejs
    pi-coding-agent
    #rustc
    #cargo
    #rustfmt
    #clippy
    (python.withPackages (ps: [
      ps.pip
      ps.torch
      ps.matplotlib
      ps.numpy
      #ps.pandas
      #ps.scipy
      #ps.scikit-learn
      ps.transformers
      ps.datasets
      ps.tiktoken
      #ps.tqdm
      #ps.wandb
      #ps.jupyterlab
      #ps.ipykernel
      ps.pytest
    ]))
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source = 
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source = 
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source = 
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;    # ghost text from history
    syntaxHighlighting.enable = true; # commands turn green when valid
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    initExtra = ''
      bindkey '^f' autosuggest-accept
      eval "$(${pkgs.coreutils}/bin/dircolors -b)"
      alias ls='${pkgs.coreutils}/bin/ls --color=auto'
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
      vim = "nvim";
    };
  };

  programs.git.settings.user = {
    name = "haglis";
    email = "lvjianhua@gmail.com";
  };
  
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
	success_symbol = "[>](purple)";
	error_symbol = "[>](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };
}
