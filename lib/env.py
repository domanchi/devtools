from enum import Enum
from functools import lru_cache
import os
import warnings


class OperatingSystem(Enum):
    UNKNOWN = None
    OSX = 'osx'
    LINUX = 'ubuntu'
    WINDOWS = 'wsl'


@lru_cache(maxsize=1)
def get_environment() -> str:
    """
    Attempts to heuristically obtain the operating system that
    this script is run under.
    """
    if os.environ.get('DEVTOOLS_OS'):
        try:
            return OperatingSystem(os.environ.get('DEVTOOLS_OS'))
        except ValueError:
            warnings.warn(
                'Passed in invalid environment variable: DEVTOOLS_OS. '
                'Falling back to default behavior...'
            )

    # NOTE: We *can* use platform.system(), but on WSL, this would
    #       return "Linux", which I'm not sure we currently want.
    if os.path.isfile('/usr/bin/sw_vers'):
        return OperatingSystem.OSX

    return OperatingSystem.UNKNOWN
