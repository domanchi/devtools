[ -f ~/.bashrc ] && source ~/.bashrc
for FN in ~/.bash_modules/*.sh; do
    source "$FN"
done

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
