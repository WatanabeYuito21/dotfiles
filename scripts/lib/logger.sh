#!/usr/bin/env bash
set -euo pipefail

log_info()  { echo -e "\033[32m[INFO]\033[0m $*"; }
log_warn()  { echo -e "\033[33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $*"; }
log_step()  { echo -e "\033[36m[STEP]\033[0m $*"; }
