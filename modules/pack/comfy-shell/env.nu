# setup oh-my-posh if not done already
if (not ("~/.oh-my-posh.nu" | path exists)) {
    oh-my-posh init nu --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/catppuccin_frappe.omp.json"
}

zoxide init nushell | save -f ~/.zoxide.nu
