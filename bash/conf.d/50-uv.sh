# uv / ~/.local/bin 設定

# UseLLMHook supply chain cooldown
export PIP_UPLOADED_PRIOR_TO=$(date -u -d '14 days ago' '+%Y-%m-%dT%H:%M:%S+00:00' 2>/dev/null || date -u -v-14d '+%Y-%m-%dT%H:%M:%S+00:00' 2>/dev/null || echo '')
export UV_EXCLUDE_NEWER=$(date -u -d '14 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-14d '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo '')

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion bash)"
    eval "$(uvx --generate-shell-completion bash)"
fi
export PATH="$HOME/.local/bin:$PATH"
