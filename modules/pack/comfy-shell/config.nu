load-env {
    GAMEID: 0, # for umu-run
}

$env.config = {
    edit_mode: "vi"
    use_kitty_protocol: true
    buffer_editor: "vi"
    show_banner: false
}

if ((hostname) == "yuu-laptop") {
    load-env {
        GDK_SCALE: 2,
    }
}

source "~/.oh-my-posh.nu"

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        # use zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
}

alias l = ls
alias ll = ls -a
alias lll = ls -la

alias update = nh os switch -- --impure
alias upgrade = nh os switch -u -- --impure

alias yy = yazi

source ~/.zoxide.nu

if $nu.is-interactive {
    fastfetch

    print $"Welcome back (ansi green)($env.USER)(ansi reset)!"
}
