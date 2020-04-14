from glob import glob
from typing import Dict
import os
import textwrap

from .env import get_environment
from .util import get_path_to
from .util import force_create_symlink


def install_bash_configs(root: str = '~'):
    modules = _get_modules()
    _assert_no_conflicts(modules)

    _create_modules_directory(
        modules,
        root=os.path.join(root, '.bash_modules'),
    )
    _write_bash_profile(root)


def _get_modules() -> Dict[str, str]:
    modules = {}

    loadable_modules = [
        get_path_to('configs/common/bash'),
    ]
    env = get_environment().value
    if env:
        loadable_modules.append(
            get_path_to(f'configs/env/{env}/bash'),
        )

    for root in loadable_modules:
        for path in glob(os.path.join(root, '[0-9][0-9][0-9].*.sh')):
            modules[os.path.basename(path)] = path

    return modules


def _assert_no_conflicts(modules: Dict[str, str]):
    precedence_numbers = set([])
    for key in modules:
        number = key.split('.')[0]
        if number not in precedence_numbers:
            precedence_numbers.add(number)
            continue

        duplicates = [
            value[len(get_path_to()) + 1:]
            for key, value in modules.items()
            if key.startswith(number)
        ]
        raise AssertionError(
            'Conflicting bash module order: ' +
            ', '.join(duplicates)
        )


def _create_modules_directory(
    modules: Dict[str, str],
    root: str = '~/.bash_modules',
):
    """
    Creating this directory achieves two objectives:
      1. Unified modular scripts, configured per ecosystem.
         Instead of loading from one directory, then another
         (which causes the problem of knowing which one to load first)
         we just throw all of them in the same directory and load
         modules from that one directory.

      2. Supporting local modules.
         We need a way to add modules to the local machine, without
         having it sync'ed up with everything else. This way, the
         directory lives on disk, until we decide to move it under
         source control.
    """
    root = os.path.expanduser(root)
    if not os.path.isdir(root):
        os.mkdir(root)

    for name, source in modules.items():
        force_create_symlink(
            source,
            os.path.join(root, name),
        )


def _write_bash_profile(root: str):
    """
    Once again, we keep a local copy of this file so that local
    modifications can be made without syncing to source control.
    """
    payload = textwrap.dedent(f"""
        for FN in {os.path.join(root, '.bash_modules')}/*.sh; do
            source "$FN"
        done
    """)[1:]

    root = os.path.expanduser(root)
    filename = os.path.join(root, '.bash_profile')
    try:
        with open(filename) as f:
            existing_content = f.read()
            if payload in existing_content:
                # Already installed!
                return
    except FileNotFoundError:
        existing_content = ''
    
    with open(filename, 'w') as f:
        f.write(existing_content)

        try:
            has_new_line = existing_content[-1] == '\n'
        except IndexError:
            # No content, so don't need to worry about separation.
            has_new_line = True

        if not has_new_line:
            f.write('\n')

        f.write(payload)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-l',
        '--list',
        action='store_true',
    )

    args = parser.parse_args()
    if args.list:
        modules = _get_modules()
        for key in sorted(modules.keys()):
            prefixes = {
                'common',
                'osx',
                'wsl',
                'ubuntu',
            }
            for prefix in prefixes:
                if f'/{prefix}' in modules[key]:
                    break

            print(f'{prefix}:{key}')
    else: 
        install_bash_configs()
