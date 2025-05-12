# setup oh-my-posh if not done already
if (not ("~/.oh-my-posh.nu" | path exists)) {
    oh-my-posh init nu --config $env.POSH_THEME
}

zoxide init nushell | save -f ~/.zoxide.nu
