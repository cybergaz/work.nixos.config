if status is-interactive
    # Commands to run in interactive sessions can go here

    # ---------------------------------------------------
    # environment variables
    # ---------------------------------------------------
    set -x EDITOR nvim

    # ---------------------------------------------------
    # zoxide initialization
    # ---------------------------------------------------
    zoxide init fish | source

    # ---------------------------------------------------
    # direnv initialization
    # ---------------------------------------------------
    direnv hook fish | source


    # ---------------------------------------------------
    # alias & functions
    # ---------------------------------------------------

    # core utils rust replacements
    function ls
        if type -q eza
            eza -a $argv
        else
            command ls -a --color=auto $argv
        end
    end
    function l
        if type -q eza
            eza -la $argv
        else
            command ls -la --color=auto $argv
        end
    end
    function grep
        if type -q rg
            rg $argv
        else
            command grep --color=auto $argv
        end
    end
    function cp
        if type -q xcp
            xcp -r $argv
        else
            command cp -r $argv
        end
    end
    # alias ls="eza -a"
    # alias l="eza -la"
    # alias grep="rg"
    # alias cp="xcp -r"
    alias du="dust"
    alias zip="zip -r"
    alias unzip="ripunzip unzip-file"
    alias c="clear"

    # neovim
    alias vim="nvim"
    alias nv="nvim"
    alias lv="nvim -c 'lua require(\"persistence\").select()'"
    alias sunv="sudo -E -s nvim"

    # tmux
    alias tm="tmux"

    function tn
        set default "dev"
        set input (string trim -- $argv[1])
        if test -n "$input"
            set session "$input"
        else
            set session $default
        end
        tmux new-session -A -s $session 'nvim; exec fish'
    end

    # zoxide + tmux + neovim
    function zn
        # argparse 'n/name=' -- $argv
        # or return 1
        #
        # if test -z "$_flag_name"
        #     echo "zn: session name required. Usage: zn -n <name> <query...>" >&2
        #     return 1
        # end
        if test (count $argv) -lt 2
            echo "zn: require atleast 2 args. Usage: zn <query...>" >&2
            return 1
        end

        set -l dir (zoxide query $argv)
        if test -n "$dir"
            cd $dir
            tmux new-session -A -s $argv[1]-$argv[2] "nvim; exec fish"
        else
            echo "No matching directory found for '$argv'" >&2
            return 1
        end
    end

    function tma
        if test (count $argv) -eq 0
            tmux a
        else
            tmux a -t $argv[1]
        end
    end

    alias tml="tmux list-session"
    alias tk="tmux kill-session"
    alias tkk="tmux kill-server"

    # config files
    alias fishrc="vim ~/.config/fish/config.fish"

    # system
    alias ff='fastfetch --logo nixos_old'

    # nixos
    alias nixg='sudo nix-collect-garbage -d'
    alias nixs='nix search nixpkgs'
    alias nixf='nix-store --query --requisites /run/current-system | rg'
    alias nixsh='nix-shell --command fish -p'
    alias nixshi='NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nix-shell --command fish -p --impure'
    alias dev='nix develop'


    # misc
    function count-file
        set dir (test -n "$argv[1]"; and echo "$argv[1]"; or echo ".")
        find $dir -type f -printf '.' | wc -c
    end
    function count-loc
        if test (count $argv) -lt 1
            echo "Usage: count-loc <extension> [directory]"
            return 1
        end

        set ext $argv[1]
        set dir (test -n "$argv[2]"; and echo "$argv[2]"; or echo ".")

        find $dir -type f -name "*.$ext" -print0 | xargs -0 cat | wc -l
    end

    # ..................git aliases.......................
    # alias gittoken="cat $HOME/Desktop/workspace/my_token | wl-copy -n"
    alias gcl="git clone"
    alias gcld="git clone --depth 1"
    alias gcm="git commit -m"
    alias ga="git add"
    alias gps="git push"
    alias gpl="git pull"
    alias gst="git status"
    alias gck="git checkout"
    alias gbr="git branch"
    alias gsw="git switch"
    alias gm="git merge"
    alias gl="git log --all --graph --decorate"
    alias gll="git log --all --graph --oneline --decorate"
    alias gwa="git worktree add"
    alias gwl="git worktree list"
    alias gwr="git worktree remove"


    # multiple cd using dots
    function multicd
        echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
    end
    abbr --add dotdot --regex '^\.\.+$' --function multicd

    # greetings
    function fish_greeting
        set h (date +"%H")

        if test $h -gt 6 -a $h -le 12
            set gt "good morning"
        else if test $h -gt 12 -a $h -le 17
            set gt "good afternoon"
        else if test $h -gt 17 -a $h -le 23
            set gt "good evening"
        else
            set gt "good to see you"
        end

        set user (whoami)

        set msg "$(random choice "...:: welcome back sir ::..." "..:: hi $user , welcome, once again ::.." "..:: $gt $user , what do you have for me  ::.." "...:: here you go ::..." "Hello $user..::..How are you?" "..:: on your demand boss ::.." "..:: ready to receive commands sir ::.." "...:: hello $user , $gt ::..." "..:: $gt sir ::.." "..:: ready for action as always ::.." "..:: Hungry for commands boss ::.." "..:: $gt $user , what's next?" "..:: nice to see you again $user ::..." "..:: $gt $user , how are you ::.." "..:: welcome back sir ::.." "..:: what do you want ::.." "..:: just type it ::.." "..:: give me a command already ::.." "..:: what do you want this time huh ? ::.." "..:: at your service sir ::.." "..:: $gt sir , long time no see ! ::..") "
        if type -q lolcrab
            echo $msg
        else
            echo $msg
        end
        # echo "{ you have $(wc -l $HOME/.tasks | awk '{ print $1 }') tasks pending }"

        # echo $li[(math (random) % (count $li))] | lolcat
    end

    # ---------------------------------------------------
    # keybinds
    # ---------------------------------------------------
    bind ctrl-l 'accept-autosuggestion'
    bind ctrl-k 'history-search-backward'
    bind ctrl-j 'history-search-forward'

end

# Non-inggml-base.en.binteractive mode is used when the shell is executing a script or commands without direct user interaction.
# set -ax PATH ~/go/bin
