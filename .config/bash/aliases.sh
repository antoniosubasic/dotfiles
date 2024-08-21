# ripgrep
alias grep='rg'

# bat
alias bat='batcat --theme "Visual Studio Dark+"'

# eza - https://github.com/eza-community/eza?tab=readme-ov-file#display-options
alias ls='eza --time-style=+"%d.%m.%Y %H:%M:%S" --color=always'
alias ll='ls -al'
alias tree='ls -T'

# zoxide
eval "$(zoxide init bash)"
alias cd='z'

# xsel
alias copy='xsel --input --clipboard'
alias paste='xsel --output --clipboard'

# cd
alias ..='cd ..'
alias ...='cd ../..'
