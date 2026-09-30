# Python環境設定（pyenv for Linux）

# pyenv設定（WSL2/Linux用）
if [ -d "$HOME/.pyenv" ] && command -v pyenv &>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    [[ ":$PATH:" != *":$PYENV_ROOT/shims:"* ]] && export PATH="$PYENV_ROOT/shims:$PATH"
    export PYENV_SHELL=bash
    source "$PYENV_ROOT/completions/pyenv.bash" 2>/dev/null
    command pyenv rehash 2>/dev/null
    pyenv() {
        local command="${1:-}"
        [ "$#" -gt 0 ] && shift
        case "$command" in
        activate|deactivate|rehash|shell)
            eval "$(pyenv "sh-$command" "$@")";;
        *)
            command pyenv "$command" "$@";;
        esac
    }
fi
