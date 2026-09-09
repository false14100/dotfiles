# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end

# -----------------------------------------------------------------------------
# 1. ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------
# supress fish greetings
set -U fish_greeting
set -gx EDITOR nvim
set -gx VISUAL nvim

# Go
set -gx GOPATH $HOME/.local/share/go

# Ruby gems
set -gx GEM_HOME $HOME/.local/bin/gem
set -gx GEM_PATH $HOME/.local/bin/gem

# SDKMAN (bash-only init; wrap in a function so it's lazy-loaded)
set -gx SDKMAN_DIR $HOME/.sdkman


# -----------------------------------------------------------------------------
# 2. PATH  (fish_add_path is idempotent — safe to call every session)
# -----------------------------------------------------------------------------

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/scripts

# Go
fish_add_path $GOPATH/bin
fish_add_path /usr/local/go/bin

# GHCup (Haskell)
if test -f $HOME/.ghcup/env
    source $HOME/.ghcup/env
end

# OPAM (OCaml)
if test -r $HOME/.opam/opam-init/init.fish
    source $HOME/.opam/opam-init/init.fish 2>/dev/null
end

# fnm (Node.js version manager)
set -l FNM_PATH $HOME/.local/share/fnm
if test -d $FNM_PATH
    fish_add_path $FNM_PATH
    fnm env | source
end

# asdf shims
if test -d $HOME/.asdf
    fish_add_path $HOME/.asdf/shims
end


# -----------------------------------------------------------------------------
# 3. ALIASES  (use 'alias' for simple renames; functions/ for anything complex)
# -----------------------------------------------------------------------------

alias ls   'ls --color=auto'
alias ll   'ls -al'
alias grep 'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'
alias tree 'find . | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
alias lf   'yazi'
alias tmux 'tmux -u'
alias ti   'tmux-init'
alias ta   'tmux a'
alias btop 'btop --force-utf'
alias ovim 'NVIM_APPNAME=ovim nvim'

# -----------------------------------------------------------------------------
# 4. KEY BINDINGS  (single function — only the last definition wins in Fish)
# -----------------------------------------------------------------------------

function fish_user_key_bindings
    # Base: vi mode
    fish_vi_key_bindings

    # hjkl navigate completions/pager in insert mode;
    # fall through to normal character insertion otherwise
    bind -M insert h 'if commandline --paging-mode; commandline -f backward-char; else; commandline -i h; end'
    bind -M insert j 'if commandline --paging-mode; commandline -f down-line;     else; commandline -i j; end'
    bind -M insert k 'if commandline --paging-mode; commandline -f up-line;       else; commandline -i k; end'
    bind -M insert l 'if commandline --paging-mode; commandline -f forward-char;  else; commandline -i l; end'

    # Ctrl+Y: accept autosuggestion (both modes)
    bind \cy accept-autosuggestion
    bind -M insert \cy accept-autosuggestion
end


# -----------------------------------------------------------------------------
# 5. TOOLS  (zoxide, fzf — must come after PATH is set)
# -----------------------------------------------------------------------------

# zoxide: smarter cd
if command -v zoxide >/dev/null 2>&1
    zoxide init fish --cmd cd | source
end

# fzf: key bindings + completion
if command -v fzf >/dev/null 2>&1
    fzf --fish | source
end


# -----------------------------------------------------------------------------
# 6. FZF THEME
# -----------------------------------------------------------------------------

set -l color00 '#151515'
set -l color01 '#202020'
set -l color02 '#303030'
set -l color03 '#505050'
set -l color04 '#b0b0b0'
set -l color05 '#d0d0d0'
set -l color06 '#e0e0e0'
set -l color07 '#f5f5f5'
set -l color08 '#ac4142'
set -l color09 '#d28445'
set -l color0A '#f4bf75'
set -l color0B '#90a959'
set -l color0C '#75b5aa'
set -l color0D '#6a9fb5'
set -l color0E '#aa759f'
set -l color0F '#8f5536'

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D\
    --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C\
    --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D\
    --border \
    --info=inline \
    --height=40% \
    --layout=reverse \
    --prompt=\"> \" \
    --pointer=\"◆\" \
    --separator=\"─\" \
    --scrollbar=\"│\" \
    --marker='✓' \
    --multi"
