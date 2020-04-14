import os


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

