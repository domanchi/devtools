# devtools
> **When should you automate something?**

> A good rule of thumb is when you find yourself doing a task manually *twice*, write a tool to automate it
> *for the third time*.

This is a collection of tools that I use to become more effective in my job. Though mainly for personal use,
please feel free to borrow, edit or improve my scripts to tailor it to your own workflow.

## Quickstart

```bash
$ sudo apt update
$ make install
```

Alternatively, comment out the roles you don't need to run in `playbook.yaml`, then use the
above command to install the rest.

### Gotchas

1.  When installing the `python` role, you may encounter the following error:

    ```
    TASK [vendor/avanov.pyenv : Install development packages necessary for building Python] ********************
    fatal: [localhost]: FAILED! => {
        "changed": false
    }

    MSG:

    No package matching 'llvm' is available
    ```

    To fix this, you need to apply the following patch.

    ```patch
    *** vendor/avanov.pyenv/defaults/main.yml    2022-06-24 23:18:22.383766000 -0700
    --- vendor/avanov.pyenv/defaults/main.yml    2022-06-24 23:18:04.293766000 -0700
    @@ -31,7 +31,7 @@
       - libreadline-dev
       - zlib1g-dev
       - wget
    -  - llvm
    +  - llvm-12
       - libncurses5-dev
       - xz-utils
       - tk-dev
    ```

2.  When installing the `ruby` role, you may encounter the following stack trace:

    ```
    STDERR:

    /bin/sh: rbenv: command not found
    ```

    This is due to the (probably never going to be merged) bug:
    https://github.com/zzet/rbenv/pull/142. The fix is just to let the job fail (for now),
    and manually run `rbenv rehash`.
