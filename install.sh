#!/bin/sh
set -e
[ -n "$KB_DEBUG" ] && set -x

log_detail()  { echo "       $*" ; }

install_bash() {
  kb-chef-apply <<RECIPE
    package "bash"
RECIPE
}

git_tag() {
  local tag="$(kb-ruby -S kb-github-tags sstephenson bats | grep '^v[0-9]' | tail -n 1)"
  [ -z "$tag" ] && tag="master"
  echo $tag
}

install_bats() {
  local bats_path="$(kb-vendorpath bats)"
  local tar="/tmp/bats-$$.tar.gz"
  local extracted="${tar%%.tar.gz}"
  local url="https://github.com/sstephenson/bats/archive/$(git_tag).tar.gz"

  ( kb-download "$url" "$tar" && \
    mkdir -p "$extracted" && \
    (cd "$extracted" ; gunzip -c "$tar" | tar xf - --strip-components=1) && \
    $extracted/install.sh $bats_path && \
    rm -rf "$tar" "$extracted"
  ) || return 1
}

install_bash
install_bats
