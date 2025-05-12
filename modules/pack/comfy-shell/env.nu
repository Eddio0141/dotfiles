# setup oh-my-posh if not done already
if (not ("~/.oh-my-posh.nu" | path exists)) {
    if ($env.POSH_THEME? == null) {
        print "POSH_THEME is not defined, cannot initialize oh-my-posh!" --stderr
    } else {
        oh-my-posh init nu --config $env.POSH_THEME
    }
}

zoxide init nushell | save -f ~/.zoxide.nu
