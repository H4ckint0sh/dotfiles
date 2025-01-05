#### Transient prompt with transient newline before prompt
#### based on https://gist.github.com/subnut/3af65306fbecd35fe2dda81f59acf2b2, modified for starship

[[ -c /dev/null ]]  ||  return
zmodload zsh/system ||  return

## Set the transient prompt PROMPT here -
TRANSIENT_PROMPT='$(starship module character)'   # Sample value
PROMPT_BAK=$PROMPT  # Backup the original PROMPT
RPROMPT_BAK=$RPROMPT  # Backup the original RPROMPT

function set_prompt {
    ## Set the values of PROMPT and RPROMPT here
    # Sample values given below
    PROMPT=$PROMPT_BAK
    RPROMPT=$RPROMPT_BAK
    }

typeset -g _transient_prompt_newline=
function _transient_prompt_set_prompt {
    set_prompt
    PROMPT='$_transient_prompt_newline'$PROMPT
}; _transient_prompt_set_prompt

zle -N clear-screen _transient_prompt_widget-clear-screen
function _transient_prompt_widget-clear-screen {
    _transient_prompt_newline=
    zle .clear-screen
}

zle -N send-break _transient_prompt_widget-send-break
function _transient_prompt_widget-send-break {
    _transient_prompt_widget-zle-line-finish
    zle .send-break
}

zle -N zle-line-finish _transient_prompt_widget-zle-line-finish
function _transient_prompt_widget-zle-line-finish {
    (( ! _transient_prompt_fd )) && {
        sysopen -r -o cloexec -u _transient_prompt_fd /dev/null
        zle -F $_transient_prompt_fd _transient_prompt_restore_prompt
    }
    zle && PROMPT=$TRANSIENT_PROMPT RPROMPT= zle reset-prompt && zle -R
}

function _transient_prompt_restore_prompt {
    exec {1}>&-
    (( ${+1} )) && zle -F $1
    _transient_prompt_fd=0
    _transient_prompt_set_prompt
    zle reset-prompt
    zle -R
}

(( ${+precmd_functions} )) || typeset -ga precmd_functions
(( ${#precmd_functions} )) || {
    do_nothing() {true}
    precmd_functions=(do_nothing)
}

precmd_functions+=_transient_prompt_precmd
function _transient_prompt_precmd {
    # We define _transient_prompt_precmd in this way because we don't want
    # _transient_prompt_newline to be defined on the very first precmd.
    TRAPINT() {zle && _transient_prompt_widget-zle-line-finish; return $(( 128 + $1 ))}
    function _transient_prompt_precmd {
        TRAPINT() {zle && _transient_prompt_widget-zle-line-finish; return $(( 128 + $1 ))}
        _transient_prompt_newline=$'\n'
    }
}

# vim: sw=0 ts=4 sts=4 et
