#!/bin/sh

# From https://get.pnpm.io/install.sh
abort() {
    printf "%s\n" "$@"
    exit 1
}

validate_url() {
    local url="$1"

    if command -v curl >/dev/null 2>&1; then
        curl --output /dev/null --silent --show-error --location --head --fail "$url"
    else
        wget --spider --quiet "$url"
    fi
}

detect_platform() {
    local platform
    platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

    case "${platform}" in
        linux) platform="linux" ;;
        darwin) platform="macos" ;;
        windows) platform="windows" ;;
    esac

    printf '%s' "${platform}"
}

detect_arch() {
    local arch
    arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

    case "${arch}" in
        x86_64) arch="x86_64" ;;
        amd64) arch="x86_64" ;;
        armv*) arch="arm" ;;
        arm64 | aarch64) arch="aarch64" ;;
    esac

    # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
    if [ "${arch}" = "x86_64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
        arch=i686
    elif [ "${arch}" = "aarch64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
        arch=arm
    fi

    case "$arch" in
        x86_64*) ;;
        aarch64*) ;;
        *) return 1 ;;
    esac
    printf '%s' "${arch}"
}

# End https://get.pnpm.io/install.sh

platform="$(detect_platform)"
arch="$(detect_arch)" || abort "Sorry! Wolebase currently only provides binaries for x86_64/arm64 architectures."
archive_url="https://github.com/Wolebase/cli-releases/releases/latest/download/wolebase-cli-${arch}-${platform}.tar.xz"
validate_url "$archive_url" || abort "Sorry! it looks like Wolebase is not available for your configuration"

prefix='/usr/local'
tmp="$(mktemp -d)"
clean() { rm -rf "$tmp"; }
trap clean EXIT

if command -v curl > /dev/null 2>&1; then
    curl -fsSL --retry 5 -o "$tmp/wolebase-cli.tar.xz" "$archive_url"
else
    wget -qO "$tmp/wolebase-cli.tar.xz" "$archive_url"
fi

tar --directory "$tmp" --extract --file "$tmp/wolebase-cli.tar.xz"

run='sudo'
if test -d "$prefix/bin" && test -w "$prefix/bin"; then
    run='eval'
elif test -d "$prefix" && test -w "$prefix"; then
    run='eval'
fi

if [ "$run" = "sudo" ] && ! command -v "$run" >/dev/null; then
    echo "You do not have permissions to write in $prefix" 1>&2
    exit 1
fi

"$run" install -d "$prefix/bin" || abort "Failed to create $prefix/bin"
"$run" install -m 0755 "$tmp/wolebase" "$prefix/bin/wolebase" || abort "Failed to install"

echo "The Wolebase CLI is installed!" 1>&2
