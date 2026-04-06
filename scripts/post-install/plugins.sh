#!/usr/bin/env bash
set -euo pipefail

setup_plugins() {
    log_step "プラグインマネージャーをセットアップ中..."
    setup_lazy
    setup_tpm
}
