[ -f ~/.bashrc ] && source ~/.bashrc
for FN in ~/.bash_modules/*.sh; do
    source "$FN"
done
