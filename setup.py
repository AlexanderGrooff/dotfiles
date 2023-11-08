#!/usr/bin/env python3

from contextlib import suppress
import yaml
import os
import argparse
import jinja2
from glob import glob


SKIP_FILES = [
    "setup.py",
    ".git",
    "README.md",
    ".gitignore",
    "setup",
    "dist",
    ".stignore",
    ".gitkeep",
    ".gitmodules",
]
RENDERED_FILE_DIR = "dist"
CONFIG_FILE = os.path.expanduser('~/.config/alex.conf')


def copy_file_permissions(src, dst):
    st = os.stat(src)
    os.chmod(dst, st.st_mode)


# Render a template file with the given variables
def render_template(template_file, variables) -> str:
    with open(template_file, 'r') as f:
        template = f.read()
    rendered_contents = jinja2.Template(template).render(variables)
    rendered_file = os.path.abspath(os.path.join(RENDERED_FILE_DIR, template_file))
    os.makedirs(os.path.dirname(rendered_file), exist_ok=True)
    with open(os.path.join(RENDERED_FILE_DIR, template_file), 'w') as f:
        f.write(rendered_contents)
    copy_file_permissions(template_file, rendered_file)
    return rendered_file


# Load variables from config yaml file
def load_variables():
    with open(CONFIG_FILE, 'r') as f:
        return yaml.load(f, Loader=yaml.FullLoader)


def startswith_any(string, prefixes):
    for prefix in prefixes:
        if string.startswith(prefix):
            return True


def parse_args():
    parser = argparse.ArgumentParser(description='Symlink dotfiles to homedir')
    parser.add_argument('-f', '--force', action='store_true',
                        help='Force overwrite of existing files')
    parser.add_argument('-d', '--dry-run', action='store_true', help="Don't do anything, just print what would happen")
    return parser.parse_args()


def main():
    args = parse_args()
    variables = load_variables()
    # Loop over all files in this directory and symlink it to the homedir
    for file in list(glob("*", include_hidden=True)) + list(glob('*/**', include_hidden=True)):
        if startswith_any(file, SKIP_FILES):
            #print(f"Skipping {file}")
            continue

        if os.path.isdir(file):
            # Ensure the directory exists
            if not args.dry_run:
                os.makedirs(os.path.expanduser(f'~/{file}'), exist_ok=True)
            continue

        rendered_file = render_template(file, variables)
        if not args.dry_run:
            print(f"Symlinking {rendered_file} to ~/{file}")
            if args.force:
                with suppress(FileNotFoundError):
                    os.remove(os.path.expanduser(f'~/{file}'))
            with suppress(FileExistsError):
                os.symlink(rendered_file, os.path.expanduser('~/{}'.format(file)))

if __name__ == '__main__':
    main()
