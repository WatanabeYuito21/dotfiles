_smart_cd_hook() {
    smart-cd add "$(pwd)"
}
PROMPT_COMMAND="_smart_cd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

z() {
    local result
    result=$(smart-cd query "$@" 2>/dev/tty)
    [ -n "$result" ] && cd "$result"
}
