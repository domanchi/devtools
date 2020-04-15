from functools import lru_cache
import os

from .env import get_environment
from .env import OperatingSystem
from .exceptions import InstallError
from .util import get_path_to
from .util import force_create_symlink


def install_vscode_configs():
    root = _get_destination()
    if not os.path.isdir(root):
        print('VSCode not installed.')
        return

    _install_settings()
    return
    _install_keybindings()


def _install_settings():
    # NOTE: Currently assuming that we have a global settings file.
    #       Also assuming that we don't have any local settings that
    #       we need to worry about not overriding.
    force_create_symlink(
        get_path_to(f'configs/common/vscode/settings.json'),
        os.path.join(
            _get_destination(),
            'settings.json',
        ),
    )


def _install_keybindings():
    # TODO: This is a bit harder to do, because of the different
    # operating systems and their keys (mac has cmd, windows has win)
    # As a result, we have three possibilities:
    #   1. Merge the settings files inline
    #      We host the configs both in common/ and env/, then merge
    #      them in this function.
    #
    #   2. Replace the platform-specific keys on the fly.
    #      We can find and replace the keybindings.json file with
    #      all incorrect keys, however, this is probably a worser
    #      option. Not only will we still need to keep a local copy,
    #      but we'll also have slightly incorrect finger movements
    #      when trying to trigger those keyboard commands.
    #
    #   3. Symlink the common functionality over to User settings,
    #      and the platform specific functionality over to Workspace
    #      settings.
    #      This has a nice handy feature of sync'ed configs, however,
    #      this also fails in that for every project that you work on,
    #      you'll need to run some command to create .vscode/, and
    #      symlink the necessary file.
    #
    # Currently, I'm going to assume development on the OSX, so we
    # can punt on this issue till a later time.
    force_create_symlink(
        get_path_to(f'configs/common/vscode/keybindings.json'),
        os.path.join(
            _get_destination(),
            'keybindings.json',
        ),
    )


@lru_cache(maxsize=1)
def _get_destination() -> str:
    # Source: https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
    try:
        root = {
            OperatingSystem.OSX: (
                '~/Library/Application Support/Code/User'
            ),
            OperatingSystem.LINUX: '~/.config/Code/User',
        }[get_environment()]
    except KeyError:
        raise InstallError(
            'Unable to find destination for VSCode configs.'
        )

    return os.path.expanduser(root)


if __name__ == '__main__':
    install_vscode_configs()    
