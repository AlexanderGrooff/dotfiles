#!/usr/bin/env python3
from pathlib import Path
import sys
import re
import time

from contextlib import suppress
import yaml
import os
import argparse
import jinja2
from glob import glob
import logging

logger = logging.getLogger(__name__)


SKIP_FILE_PATTERNS = [
    r".direnv$",
    r"\.envrc",
    r".git$",
    r".gitignore$",
    r".gitkeep",
    r".gitmodules",
    r".stignore",
    r"dist$",
    r"fix_remote.sh",
    r"README.md",
    r"setup$",
    r"setup_lite$",
    r"symlink",
    r".venv$",
    r"requirements.txt",
    
    # Home manager configs
    r"ssh_config",
    r"flake.lock",
    r"flake.nix",
    r"home.nix",
]


def parse_args():
    parser = argparse.ArgumentParser(description='Symlink dotfiles to homedir')
    parser.add_argument('-f', '--force', action='store_true',
                        help='Force overwrite of existing files')
    parser.add_argument('-d', '--dry-run', action='store_true', help="Don't do anything, just logger.debug what would happen")
    parser.add_argument("-v", "--verbose", action="store_true", help="Verbose logging")
    return parser.parse_args()


def render_dotfile(file, dry_run=False, force=False):
    f = Path(file)
    if not dry_run:
        if force:
            with suppress(FileNotFoundError):
                logger.debug(f"Removing {file}")
                f.unlink()
        with suppress(FileExistsError):
            logger.debug(f"Linking {file} to ~/{file}")
            os.symlink(f.resolve(), os.path.expanduser('~/{}'.format(file)))
    else:
        logger.debug(f"Would have linked {file} to ~/{file}")


def loop_over_dir(dir, args):
    for file in list(glob(f"{dir}/*", include_hidden=True)):
        to_skip = False
        for skip_pattern in SKIP_FILE_PATTERNS:
            if re.findall(skip_pattern, file):
                #logger.debug(f"Skipping {file} because it matches {skip_pattern}")
                to_skip = True
                break
        if to_skip:
            continue
        if os.path.isdir(file):
            if not args.dry_run:
                os.makedirs(os.path.expanduser(f'~/{file}'), exist_ok=True)
            else:
                logger.debug(f"Would have mkdir -p ~/{file=}")
            loop_over_dir(file, args)
        else:
            render_dotfile(file, args.dry_run, args.force)

def is_already_linked(file: str) -> bool:
    if not os.path.islink(file):
        return False
    return True


def render_all_files(args):
    # Loop over all files in this directory and symlink it to the homedir
    loop_over_dir('.', args)


def main():
    args = parse_args()
    logging.basicConfig(level=logging.DEBUG)

    render_all_files(args)

if __name__ == '__main__':
    main()
