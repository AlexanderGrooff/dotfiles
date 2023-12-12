#!/usr/bin/env python3
import sys
import re
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from loguru import logger

from contextlib import suppress
import yaml
import os
import argparse
import jinja2
from glob import glob


SKIP_FILE_PATTERNS = [
    "\.envrc",
    ".git/",
    ".gitignore$",
    ".gitkeep",
    ".gitmodules",
    ".stignore",
    "dist/.*",
    "fix_remote.sh",
    "README.md",
    "setup.py",
    "setup",
    ".venv",
    os.path.basename(__file__),
]
RENDERED_FILE_DIR = "dist"
CONFIG_FILE = os.path.expanduser('~/.config/alex.conf')


def copy_file_permissions(src, dst):
    st = os.stat(src)
    os.chmod(dst, st.st_mode)


# Render a template file with the given variables
def render_template(template_file, variables) -> str:
    try:
        with open(template_file, 'r') as f:
            template = f.read()
    except UnicodeDecodeError:
        logger.debug(f"Skipping templating {template_file} because it's a binary file")
        return template_file
    
    try:
        rendered_contents = jinja2.Template(template).render(variables)
    except jinja2.exceptions.TemplateSyntaxError as e:
        logger.debug(f"Error rendering {template_file}: {e}")
        return template_file
    rendered_file = os.path.abspath(os.path.join(RENDERED_FILE_DIR, template_file))
    os.makedirs(os.path.dirname(rendered_file), exist_ok=True)
    if os.path.exists(rendered_file):
        old_contents = open(rendered_file, 'r').read()
    else:
        logger.info(f"Creating missing file {rendered_file}")
        old_contents = ""
    with open(os.path.join(RENDERED_FILE_DIR, template_file), 'w') as f:
        f.write(rendered_contents)
    copy_file_permissions(template_file, rendered_file)

    if old_contents != rendered_contents:
        logger.info(f"Updated contents for {template_file}")

    return rendered_file


# Load variables from config yaml file
def load_variables():
    # Ensure file exists
    if not os.path.exists(CONFIG_FILE):
        logger.debug(f"Creating missing config file {CONFIG_FILE}")
        os.makedirs(os.path.dirname(CONFIG_FILE), exist_ok=True)
        with open(CONFIG_FILE, 'w') as f:
            f.write('')

    with open(CONFIG_FILE, 'r') as f:
        return yaml.load(f, Loader=yaml.FullLoader)


def parse_args():
    parser = argparse.ArgumentParser(description='Symlink dotfiles to homedir')
    parser.add_argument('-f', '--force', action='store_true',
                        help='Force overwrite of existing files')
    parser.add_argument('-d', '--dry-run', action='store_true', help="Don't do anything, just logger.debug what would happen")
    parser.add_argument("--watch", action="store_true", help="Watch for changes and re-run")
    parser.add_argument("-v", "--verbose", action="store_true", help="Verbose logging")
    return parser.parse_args()


def render_dotfile(file, render_variables, dry_run=False, force=False):
    rendered_file = render_template(file, render_variables)
    if not dry_run:
        if force:
            with suppress(FileNotFoundError):
                os.remove(os.path.expanduser(f'~/{file}'))
                logger.debug(f"Removed ~/{file}")
        with suppress(FileExistsError):
            os.symlink(rendered_file, os.path.expanduser('~/{}'.format(file)))
            logger.debug(f"Linked {rendered_file} to ~/{file}")


def is_dotfile(file: str) -> bool:
    for skip_pattern in SKIP_FILE_PATTERNS:
        if re.findall(skip_pattern, file):
            #logger.debug(f"Skipping {file} because it matches {skip_pattern}")
            return False
    return True


def loop_over_dir(dir, variables, args):
    for file in list(glob(f"{dir}/*", include_hidden=True)) + list(glob(f'{dir}/*/**', include_hidden=True)):
        if os.path.isdir(file):
            os.makedirs(os.path.expanduser(f'~/{file}'), exist_ok=True)
            loop_over_dir(file, variables, args)
            continue
        if is_dotfile(file):
            render_dotfile(file, variables, args.dry_run, args.force)


def render_all_files(args):
    variables = load_variables()

    # Loop over all files in this directory and symlink it to the homedir
    loop_over_dir('.', variables, args)


def watch_files(args):
    class Handler(FileSystemEventHandler):
        def on_any_event(self, event):
            if event.event_type in ["modified"] and is_dotfile(event.src_path):
                logger.debug(f"Found event {event}")
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


def setup_logging(verbose: bool):
    logger.remove()
    logger.add(sys.stderr, level="INFO")
    if verbose:
        logger.add(sys.stderr, level="DEBUG")


def main():
    args = parse_args()
    setup_logging(args.verbose)

    if args.watch:
        watch_files(args)
    else:
        render_all_files(args)

if __name__ == '__main__':
    main()
