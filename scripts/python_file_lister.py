#!/usr/bin/env python3
import os
import sys


def get_base_prefix_compat():
    """Get base/real prefix, or sys.prefix if there is none."""
    return getattr(sys, "base_prefix", None) or \
        getattr(sys, "real_prefix", None) or sys.prefix


def in_virtualenv():
    return get_base_prefix_compat() != sys.prefix


def files_in_tree(dir):
    subfolders, files = [], []

    for f in os.scandir(dir):
        if f.is_dir():
            subfolders.append(f.path)
        if f.is_file():
            files.append(f.path)

    for d in subfolders:
        f = files_in_tree(d)
        files.extend(f)
    return files


def print_all_files(dirs):
    files = []
    for d in dirs:
        if not os.path.isdir(d):
            continue
        dirpath = os.path.abspath(os.path.expanduser(d))
        f = files_in_tree(dirpath)
        files.extend(f)

    print('\n'.join('{}'.format(f) for f in files))


if in_virtualenv():
    print_all_files(sys.path)
else:
    print_all_files('.')
