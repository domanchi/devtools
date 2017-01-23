## Installation Notes

This activates the autocomplete on bash shells.

```
pip install argcomplete
chmod +x main.py
```

Note that `register-python-argcomplete` will add the "complete" script to bash.
To view all "complete" scripts, you can input `complete`.

However, this doesn't work straight out of the box with aliasing, because
complete will not resolve the alias before trying to autocomplete it. Thus,
we have to create our own bash function resolver.

```
function _python_argcomplete_notes() {
    _python_argcomplete "$DEVTOOLS_BASEPATH/useful/toolset/main.py" $2 $3
}

complete -o default -o nospace -F _python_argcomplete_notes notes
```

This above code block has already been intergrated in devtools.
