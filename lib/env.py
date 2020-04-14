from enum import Enum
from functools import lru_cache
import os


class OperatingSystem(Enum):
    UNKNOWN = None
    OSX = 'osx'


@lru_cache(maxsize=1)
def get_environment() -> str:
    """
    Attempts to heuristically obtain the operating system that
    this script is run under.
    """
    if os.path.isfile('/usr/bin/sw_vers'):
        return OperatingSystem.OSX

    return OperatingSystem.UNKNOWN
