# devtools
> **When should you automate something?**

> A good rule of thumb is when you find yourself doing a task manually *twice*, write a tool to automate it *for the third time*.

This is a collection of tools that I use to become more effective in my job. Though mainly for personal use,
please feel free to borrow, edit or improve my scripts to tailor it to your own workflow.

### Tools
Tools include:
- git/cleanup : remove an inactive branch, both locally and remotely
- git/submodule : update a git submodule
- git/switch_branch : an efficient way to switch git branches with long names.
- mac/app_interface : (Mac specific) interact with various applications on command line.
- php/phpclean : use phpcbf to clean to-be-committed php files, so that it will comply with style-guide.
- php/phpunit : easily run single tests with phpunit.
- useful/untar : unzipping all sorts of tar files, so you don't have to remember those funky flags.

### Layout
#### /configs
These configuration files are abridged saved copies of keyboard shortcuts and preferences I use for my favorite applications.

#### /scripts
These are bash scripts that automate certain manual tasks that I find myself doing over and over again. Previously, these
existed as a random assortment of local scripts; however, after being inspired by the following quote, I decided to invest
a little bit more time in maintaining my toolset, with the goal of being able to move into a new environment, clone this repo,
and get right down to business.

A recent addition to this tooling set is the ability to modularize bash scripts with **namespaces**. Simple, clean, manageable
code is good code, so I designed an interface which allows me to divide my scripts into sensible chunks, and import them
as needed. For more information, see [/scripts/main.sh] (https://github.com/domanchi/devtools/blob/master/scripts/main.sh).

### Installation
#### /configs
Just override (or merge) your existing config files with these ones. 'nuf said.

To have a better vim experience, you can also create a symlink to the config files.
This is done through the following method:

```
ln -sf ~/devtools/configs/.vimrc ~/.vimrc
ln -sf ~/devtools/configs/.vimfns ~/.vimfns
ln -sf ~/devtools/configs/.tmux.conf ~/.tmux.conf
ln -sf ~/devtools/configs/tmux ~/tmux
```

#### /scripts
Within your `~/.bash_profile`, include the following line:
```
# This will import all functionality from devtools.
. /path/to/devtools/scripts/main.sh
```

You may need to `chmod +x scripts/main.sh` in order to make it work. Also, you can configure the features/functionality you
want within main.sh.

For adding additional modules, I have used the following conventions:
- All functions need to be declared as `function function_name()` rather than just `function_name()`
- All modules should have two functions, `_usage()` and `_main()`. Usage will print a user-friendly message on how to use
the script, and main will be called automatically when you refer to the filename with `call` (unless you want to specifically
refer to the function you want to call within that namespace). For more information, see [/scripts/common/core.sh]
(https://github.com/domanchi/devtools/blob/master/scripts/common/core.sh)
- Modules may require locally defined GLOBAL variables (because bash doesn't pass variables around very well). These can be defined in `_config()` and unset in `_destructor()`, and `call()` will automatically call these constructor/destructors.

#### Windows

- `vscode`

To be compatible with VSCode, we need to make a symbolic link with `cmd`, and have the file in a location where
Windows can access it. For some reason, Windows also doesn't like symbolic links that WSL makes (`ln -s`).

```
mklink %APPDATA%\Code\User\keybindings.json devtools\configs\common\vscode\keybindings.json
mklink %APPDATA%\Code\User\settings.json devtools\configs\common\vscode\settings.json
```

### Roadmap
- There seems to be a multithreading issue with when initializing multiple bash
instances at once. Look into atomic functionality.
