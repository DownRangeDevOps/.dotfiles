#! /usr/bin/env bash
# vim: set ft=bash:

# Headers and colors
function header() {
    printf "\n%b\n" "\x1b[1m==> ${*}\x1b[0m"
}

function reset() {
    "\x1b[0m"
}

function green() {
    "\x1b[32;01m${*}\x1b[0m"
}

function yellow() {
    "\x1b[33;01m${*}\x1b[0m"
}

function red() {
    "\x1b[33;31m${*}\x1b[0m"
}

function indent_output() {
    sed "s/^/    /"
}
