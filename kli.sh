#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_KLI_VERSION=v1.0-alpha.4

show_help() {
cat << EOF
Usage: $(basename "$0") <options>
    -h, --help          Display help
    -v, --version       The kli version to use (default: $DEFAULT_KLI_VERSION)"
EOF
}

main() {
    local version="$DEFAULT_KLI_VERSION"

    parse_command_line "$@"

    install_kli
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -v|--version)
                if [[ -n "${2:-}" ]]; then
                    version="$2"
                    shift
                else
                    echo "ERROR: '-v|--version' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done
}

install_kli() {
    if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
        echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
        exit 1
    fi

    local arch
    arch=$(uname -m)
    local cache_dir="$RUNNER_TOOL_CACHE/kli/$version/$arch"

    if [[ ! -d "$cache_dir" ]]; then
        mkdir -p "$cache_dir"
        echo "Installing kli..."
        curl -sSLo kli.tar.gz "https://github.com/konstellation-io/kli/releases/download/$version/kli_${version#v}_linux_amd64.tar.gz"
        tar -xzf kli.tar.gz -C "$cache_dir"
        rm -f kli.tar.gz
    fi

    echo 'Adding kli directory to PATH...'
    echo "$cache_dir" >> "$GITHUB_PATH"
    mv "$cache_dir/kli_${version#v}_linux_amd64/bin/kli" "$cache_dir/kli"

    "$cache_dir/kli" version
}

main "$@"
