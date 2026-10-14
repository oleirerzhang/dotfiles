
# Personal command wrappers tracked by the dotfiles repository.
export PATH="$HOME/.local/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("${HOME}/opt/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Persist command history for zsh tools such as thefuck.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_dups

#--- General zsh scripts: ----
# rmcwd and move to parent
rmcwd() {
  local dir="$PWD"
  cd .. || return
  rm -rf "$dir"
}

# mkdir && cd into folder shortcut
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Follow logs live without wrapping long lines: `follow app.log` or `cmd 2>&1 | follow`
alias follow='less -RS +F'

# Ebook to PDF shortcuts
alias ebook-convert="/Applications/calibre.app/Contents/MacOS/ebook-convert"

epub2pdf() {
  if [ -z "$1" ]; then
    echo "Usage: epub2pdf <file.epub>"
    return 1
  fi

  input="$1"
  output="${input%.*}.pdf"

  ebook-convert "$input" "$output" \
    --pdf-page-numbers \
    --paper-size a4
}

azw32pdf() {
  if [ -z "$1" ]; then
    echo "Usage: azw32pdf <file.azw3>"
    return 1
  fi

  input="$1"
  output="${input%.*}.pdf"

  ebook-convert "$input" "$output" \
    --pdf-page-numbers \
    --paper-size a4
}

book2pdf() {
  if [ -z "$1" ]; then
    echo "Usage: book2pdf <file.epub|file.azw3>"
    return 1
  fi

  input="$1"
  output="${input%.*}.pdf"

  ebook-convert "$input" "$output" \
    --pdf-page-numbers \
    --paper-size a4
}

# Vi-style command line editing.
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_ESCAPE_KEYTIMEOUT=0.03
}

function _macos_select_backward_char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-char
}

function _macos_select_forward_char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-char
}

function _macos_select_backward_word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-word
}

function _macos_select_forward_word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-word
}

function _macos_select_beginning_of_line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle beginning-of-line
}

function _macos_select_end_of_line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle end-of-line
}

zle -N _macos_select_backward_char
zle -N _macos_select_forward_char
zle -N _macos_select_backward_word
zle -N _macos_select_forward_word
zle -N _macos_select_beginning_of_line
zle -N _macos_select_end_of_line

function _macos_prompt_keybindings() {
  bindkey -M viins '^[b' backward-word
  bindkey -M viins '^[f' forward-word
  bindkey -M viins '^A' beginning-of-line
  bindkey -M viins '^E' end-of-line
  bindkey -M viins '^[[1;2D' _macos_select_backward_char
  bindkey -M viins '^[[1;2C' _macos_select_forward_char
  bindkey -M viins '^[[1;4D' _macos_select_backward_word
  bindkey -M viins '^[[1;4C' _macos_select_forward_word
  bindkey -M viins '^[[1;10D' _macos_select_beginning_of_line
  bindkey -M viins '^[[1;10C' _macos_select_end_of_line
}

function zvm_after_init() {
  source <(fzf --zsh)
  _macos_prompt_keybindings
}

source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
_macos_prompt_keybindings

# Suggest commands from history as you type.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Smarter directory jumping with zoxide.
eval "$(/opt/homebrew/bin/zoxide init zsh)"

# Enable zsh's completion system before loading completion providers.
autoload -Uz compinit
compinit

# Rich command completions across many CLI tools.
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(/opt/homebrew/bin/carapace _carapace zsh)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# -- thefuck alias --
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---Eza--:  better ls:
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# detailed listing including hidden files
alias la="eza -lah --icons --git"

# better tree:
alias tree="eza --tree --icons"

# Prompt
eval "$(/opt/homebrew/bin/starship init zsh)"


# -- gh --:
ghrep() {
  local owner visibility selected

  case "$1" in
    public|private|internal|all)
      owner=""
      visibility="$1"
      ;;
    "")
      owner=""
      visibility="all"
      ;;
    *)
      owner="$1"
      visibility="${2:-all}"
      ;;
  esac

  if [[ "$visibility" != "public" && "$visibility" != "private" && "$visibility" != "internal" && "$visibility" != "all" ]]; then
    echo "Usage: ghrep [owner] [public|private|internal|all]"
    return 1
  fi

  local args=(repo list)
  [[ -n "$owner" ]] && args+=("$owner")
  args+=(--limit 500)
  [[ "$visibility" != "all" ]] && args+=(--visibility "$visibility")
  args+=(--json name,visibility,description,url,updatedAt)

  selected=$(
    gh "${args[@]}" \
      --jq '
        sort_by(.updatedAt)
        | reverse
        | .[]
        | [
            .name,
            .visibility,
            (.updatedAt | sub("T.*"; "")),
            (.description // ""),
            .url
          ]
        | @tsv
      ' \
      | awk -F '\t' '
          function trunc(s, n) {
            return length(s) > n ? substr(s, 1, n - 1) "…" : s
          }

          function vis(v) {
            if (v == "PUBLIC") return "PUB"
            if (v == "PRIVATE") return "PRI"
            if (v == "INTERNAL") return "INT"
            return v
          }

          {
            name = trunc($1, 18)
            visibility = vis($2)
            updated = $3
            desc = trunc($4, 45)
            url = $5

            display = sprintf("%-18s  %-3s  %-10s  %-45s", name, visibility, updated, desc)

            print display "\t" url
          }
        ' \
      | fzf \
          --delimiter=$'\t' \
          --with-nth=1 \
          --header="$(printf '%-18s  %-3s  %-10s  %-45s' 'repo' 'vis' 'updated' 'description')" \
          --no-hscroll \
      | cut -f2
  )

  if [ -n "$selected" ]; then
    printf "%s" "$selected" | pbcopy
    echo "Copied: $selected"
  fi
}

_gh_parse_owner_visibility() {
  case "$1" in
    public|private|internal|all)
      GH_OWNER=""
      GH_VISIBILITY="$1"
      ;;
    "")
      GH_OWNER=""
      GH_VISIBILITY="all"
      ;;
    *)
      GH_OWNER="$1"
      GH_VISIBILITY="${2:-all}"
      ;;
  esac

  if [[ "$GH_VISIBILITY" != "public" && "$GH_VISIBILITY" != "private" && "$GH_VISIBILITY" != "internal" && "$GH_VISIBILITY" != "all" ]]; then
    echo "Usage: $3 [owner] [public|private|internal|all]"
    return 1
  fi
}

_gh_repo_args() {
  GH_REPO_ARGS=(repo list)

  [[ -n "$GH_OWNER" ]] && GH_REPO_ARGS+=("$GH_OWNER")
  GH_REPO_ARGS+=(--limit 1000)
  [[ "$GH_VISIBILITY" != "all" ]] && GH_REPO_ARGS+=(--visibility "$GH_VISIBILITY")
}

# return latest updated repo:
ghlat() {
  _gh_parse_owner_visibility "$1" "$2" "ghlat" || return 1

  local -a GH_REPO_ARGS
  _gh_repo_args

  gh "${GH_REPO_ARGS[@]}" \
    --json name,updatedAt \
    --jq '
      sort_by(.updatedAt)
      | reverse
      | .[0]
      | "\(.name)\t\(.updatedAt)"
    ' \
    | awk -F '\t' '
        function epoch(t, cmd, out) {
          # macOS/BSD date
          cmd = "date -u -j -f \"%Y-%m-%dT%H:%M:%SZ\" \"" t "\" +%s"
          cmd | getline out
          close(cmd)
          return out
        }

        function now_epoch(cmd, out) {
          cmd = "date +%s"
          cmd | getline out
          close(cmd)
          return out
        }

        function ago(seconds) {
          if (seconds < 60) return seconds "s ago"
          if (seconds < 3600) return int(seconds / 60) "m ago"
          if (seconds < 86400) return int(seconds / 3600) "h ago"
          if (seconds < 2592000) return int(seconds / 86400) "d ago"
          if (seconds < 31536000) return int(seconds / 2592000) "mo ago"
          return int(seconds / 31536000) "y ago"
        }

        {
          name = $1
          updated = $2
          now = now_epoch()
          diff = now - epoch(updated)

          printf "%s — %s\n", name, ago(diff)
        }
      '
}

# return gh repo count:
ghcount() {
  _gh_parse_owner_visibility "$1" "$2" "ghcount" || return 1

  local -a GH_REPO_ARGS
  _gh_repo_args

  gh "${GH_REPO_ARGS[@]}" \
    --json name \
    --jq 'length'
}

# --- Python environment stuff ---
alias markitdown='~/tools/markitdown/.venv/bin/markitdown'

# Compile and run one C++ source file: cprun exercise.cpp [program arguments]
cprun() {
  if (( $# == 0 )); then
    echo "Usage: cprun <file.cpp> [program arguments...]" >&2
    return 2
  fi

  local source_file="$1"
  shift

  if [[ ! -f "$source_file" ]]; then
    echo "cprun: file not found: $source_file" >&2
    return 2
  fi

  local compiler
  if (( $+commands[g++-15] )); then
    compiler="g++-15"
  elif (( $+commands[clang++] )); then
    compiler="clang++"
  else
    echo "cprun: no C++ compiler found" >&2
    return 127
  fi

  local output_file="${TMPDIR:-/tmp}/cprun-${source_file:t:r}-$$"
  "$compiler" -std=c++20 -Wall -Wextra -pedantic "$source_file" -o "$output_file" || return

  "$output_file" "$@"
  local run_status=$?
  command rm -f "$output_file"
  return $run_status
}

# Unity CLI. Guarded because the file only exists once Unity Hub has run, and
# written relative to $HOME so it survives a different account name.
[ -r "$HOME/.unity/env" ] && . "$HOME/.unity/env"
