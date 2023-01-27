#!/usr/bin/env bash

set -euo pipefail

# Ensure this is the correct GitHub homepage where releases can be downloaded for headless-sso.
GH_REPO="https://github.com/mziyabo/headless-sso"
TOOL_NAME="headless-sso"
# TOOL_TEST="headless-sso --version"
TOOL_TEST=""

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if headless-sso is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if headless-sso has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # Adapt the release URL convention for headless-sso
  url="$GH_REPO/releases/download/${version}/${TOOL_NAME}_${version}_$(get_release_nugget).tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # TODO: Assert headless-sso executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    #rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}

get_arch() {
  uname -m | tr '[:upper:]' '[:lower:]'
}

get_platform() {
  uname | tr '[:upper:]' '[:lower:]'
}

get_release_nugget() {
  local nugget

  case $(get_arch)-$(get_platform) in
  arm64-darwin)
    nugget='Darwin_arm64' ;;
  x86_64-darwin)
    nugget='x86_64-apple-darwin' ;;
  arm*-linux)
    nugget='arm-unknown-linux-gnueabihf' ;;
  x86_64-linux)
    nugget='x86_64-unknown-linux-musl' ;;
  i[3456]86-linux)
    nugget='i686-unknown-linux-musl' ;;
  x86_64-windows)
    nugget='x86_64-pc-windows-msvc' ;;
  i[3456]-windows)
    nugget='i686-pc-windows-msvc' ;;
  *)
    nugget="$(get_arch)-$(get_platform)"
  esac

  echo "${nugget}"
}
