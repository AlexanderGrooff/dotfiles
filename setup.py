#!/usr/bin/env python3
import re
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from contextlib import suppress
import yaml
import os
import argparse
import jinja2
from glob import glob


SKIP_FILE_PATTERNS = [
    ".envrc",
    ".git",
    ".gitignore",
    ".gitkeep",
    ".gitmodules",
    ".stignore",
    "dist/.*",
    "README.md",
    "setup.py",
    "setup",
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
    parser.add_argument("--watch", action="store_true", help="Watch for changes and re-run")
    return parser.parse_args()


def render_dotfile(file, render_variables, dry_run=False, force=False):
    if os.path.isdir(file):
        # Ensure the directory exists
        if not dry_run:
            os.makedirs(os.path.expanduser(f'~/{file}'), exist_ok=True)
        return

    rendered_file = render_template(file, render_variables)
    if not dry_run:
        if force:
            with suppress(FileNotFoundError):
                os.remove(os.path.expanduser(f'~/{file}'))
                print(f"Removed ~/{file}")
        with suppress(FileExistsError):
            os.symlink(rendered_file, os.path.expanduser('~/{}'.format(file)))
            print(f"Linked {rendered_file} to ~/{file}")


def is_dotfile(file: str) -> bool:
    for skip_pattern in SKIP_FILE_PATTERNS:
        if re.findall(skip_pattern, file):
            return False
    return True


def render_all_files(args):
    variables = load_variables()

    # Loop over all files in this directory and symlink it to the homedir
    for file in list(glob("*", include_hidden=True)) + list(glob('*/**', include_hidden=True)):
        if is_dotfile(file):
            render_dotfile(file, variables, args.dry_run, args.force)


def watch_files(args):
    class Handler(FileSystemEventHandler):
        def on_any_event(self, event):
            if event.event_type in ["modified"] and is_dotfile(event.src_path):
                print(f"Found event {event}")
                render_dotfile(event.src_path, load_variables(), args.dry_run, force=True)

    event_handler = Handler()
    observer = Observer()
    observer.schedule(event_handler, '.', recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()


def main():
    args = parse_args()
    if args.watch:
        watch_files(args)
    else:
        render_all_files(args)

if __name__ == '__main__':
    main()
