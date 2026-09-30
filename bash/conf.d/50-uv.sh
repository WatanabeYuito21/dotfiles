# uv / ~/.local/bin 設定

# UseLLMHook supply chain cooldown
# date を1回だけ呼び、GNU date（-d）と BSD date（-v）の両方に対応する
_cooldown_ts="$(date -u -d '14 days ago' '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || date -u -v-14d '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || true)"
if [ -n "$_cooldown_ts" ]; then
    export PIP_UPLOADED_PRIOR_TO="${_cooldown_ts}+00:00"
    export UV_EXCLUDE_NEWER="${_cooldown_ts}Z"
else
    export PIP_UPLOADED_PRIOR_TO=''
    export UV_EXCLUDE_NEWER=''
fi
unset _cooldown_ts

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion bash)"
    eval "$(uvx --generate-shell-completion bash)"
fi
export PATH="$HOME/.local/bin:$PATH"
