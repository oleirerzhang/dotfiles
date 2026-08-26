
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/oliverzhang/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/oliverzhang/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/oliverzhang/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/oliverzhang/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


eval "$(/opt/homebrew/bin/brew shellenv)"

##
# Your previous /Users/oliverzhang/.bash_profile file was backed up as /Users/oliverzhang/.bash_profile.macports-saved_2023-05-22_at_22:10:55
##

# MacPorts Installer addition on 2023-05-22_at_22:10:55: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2023-05-22_at_22:10:55: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# OpenClaw Completion. Guarded so a Mac without OpenClaw still gets a
# working login shell instead of an error on every launch.
openclaw_completion="$HOME/.openclaw/completions/openclaw.bash"
[[ -r "$openclaw_completion" ]] && source "$openclaw_completion"
