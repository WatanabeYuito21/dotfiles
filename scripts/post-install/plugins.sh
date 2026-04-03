#!/usr/bin/env bash

setup_plugins() {
    log_step "プラグインマネージャーをセットアップ中..."
    setup_lazy
    setup_tpm
}
