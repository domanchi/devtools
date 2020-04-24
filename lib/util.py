import os
import subprocess


def get_path_to(path: str = '') -> str:
    return os.path.realpath(
        os.path.join(
            os.path.dirname(__file__),
            '..',
            path,
        )
    )


def force_create_symlink(src: str, dest: str):
    try:
        os.symlink(src, dest)
    except FileExistsError:
        os.remove(dest)
        os.symlink(src, dest)


def download_file(src: str, dest: str):
    """
    :param src: url to download
    :param dest: path to save file
    """
    subprocess.call(
        [
            'curl',
            '--fail',       # fail silently, on error
            '--location',   # follow redirects
            '--create-dirs',

            '--output',
            dest,
            src,
        ],
        stderr=subprocess.DEVNULL,
    )

