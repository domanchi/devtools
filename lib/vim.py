from typing import List
import os
import pathlib
import subprocess

from .util import download_file
from .util import get_path_to
from .util import force_create_symlink


def install_vim_configs(root: str = '~'):
    root = os.path.expanduser(root)

    _create_folders(os.path.join(root, '.vim'))
    _download_plugins(os.path.join(root, '.vim/autoload'))
    _install_vimrc(os.path.join(root, '.vimrc'))

    # Install plugins at the very end.
    subprocess.call('vim +PlugInstall +qall'.split())


def _create_folders(directory: str):
    pathlib.Path(
        os.path.join(directory, 'autoload')
    ).mkdir(
        parents=True,
        exist_ok=True,
    )

    # TODO: Handle case where colors already exists (as real directory)?
    force_create_symlink(
        get_path_to('configs/common/vim/colors'),
        os.path.join(directory, 'colors'),
    )


def _download_plugins(directory: str):
    # This is the plugin manager
    download_file(
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
        os.path.join(directory, 'plug.vim'),
    )

    # Faster file access
    download_file(
        'https://raw.githubusercontent.com/junegunn/fzf/master/plugin/fzf.vim',
        os.path.join(directory, 'fzf.vim'),
    )


def _install_vimrc(filename: str):
    with open(filename, 'w') as f:
        f.write(
            '\n'.join(
                f'source {module}'
                for module in _get_modules()
            )
        )


def _get_modules() -> List[str]:
    return [
        get_path_to('configs/common/vim/plugins.vim'),
        get_path_to('configs/common/vim/vimrc'),
        get_path_to('configs/common/vim/functions.vim'),
    ]


if __name__ == '__main__':
    install_vim_configs()
