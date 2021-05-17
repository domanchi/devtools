#!/usr/bin/env python3
import os
import ssl
import stat
import certifi


STAT_0o775 = ( stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR
             | stat.S_IRGRP | stat.S_IWGRP | stat.S_IXGRP
             | stat.S_IROTH |                stat.S_IXOTH )


def main():
    openssl_ca_file = ssl.get_default_verify_paths().openssl_cafile

    # We need to first remove this file, otherwise, symlinking ain't going to work.
    try:
        os.remove(openssl_ca_file)
    except FileNotFoundError:
        pass

    os.symlink(
        os.path.abspath(certifi.where()),
        openssl_ca_file,
    )

    os.chmod(openssl_ca_file, STAT_0o775)


if __name__ == '__main__':
    main()
