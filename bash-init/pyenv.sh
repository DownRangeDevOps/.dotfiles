#!/usr/bin/env bash
eval "$($(which pyenv) init -)"
eval "$($(which pyenv) virtualenv-init -)"
$(which pyenv) virtualenvwrapper_lazy
