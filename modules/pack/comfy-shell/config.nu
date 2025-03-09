$env.config.edit_mode = "vi"
$env.config.use_kitty_protocol = true
$env.config.buffer_editor = "vi"
$env.config.show_banner = false

if $nu.is-interactive {
    fastfetch

    print $"Welcome back (ansi green)($env.USER)(ansi reset)!"
}
