#!/bin/bash

print_error() {
    dunstify -u CRITICAL -t 20000 "$1"
}

# https://wiki.hyprland.org/IPC/
# does sock exist
socket_base_dir="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE"
write_socket="$socket_base_dir/.socket.sock"
read_socket="$socket_base_dir/.socket2.sock"

if [[ ! -S "$write_socket" ]]; then
    print_error "Hyprland write socket not found"
    exit 1
fi

if [[ ! -S "$read_socket" ]]; then
    print_error "Hyprland read socket not found"
    exit 1
fi

pending_title_changes=()
yt_window_id=0

nc -U "$read_socket" | while read -r line; do
    # grab openwindow event or windowtitle event
    # openwindow format: `openwindow>>window_id,workspace_id,class,title`
    # windowtitle format: `windowtitle>>window_id`
    
    event=$(echo "$line" | cut -d '>' -f1)
    if [[ -z "$event" ]]; then
        continue
    fi
    line=${line:${#event}+2}

    if [[ "$yt_window_id" != "0" ]]; then
        # is it a closewindow event
        if [[ "$event" != "closewindow" ]]; then
            continue
        fi
        
        window_id="$line"
        if [[ "$window_id" != "$yt_window_id" ]]; then
            continue
        fi

        yt_window_id=0
        continue
    fi

    if [[ "$event" == "openwindow" ]]; then
        window_id=$(echo "$line" | cut -d ',' -f1)
        if [[ -z "$window_id" ]]; then
            continue
        fi
        line=${line:${#window_id}+1}
        tmp=$(echo "$line" | cut -d ',' -f1)
        if [[ -z "$tmp" ]]; then
            continue
        fi
        line=${line:${#tmp}+1}
        class=$(echo "$line" | cut -d ',' -f1)

        # is it firefox class
        if [[ "$class" != "firefox" ]]; then
            continue
        fi

        pending_title_changes+=("$window_id")
    elif [[ "$event" == "windowtitle" ]]; then
        window_id="$line"

        # do we have a pending title change for this window
        found=0
        for value in "${pending_title_changes[@]}"; do
            if [[ "$value" == "$window_id" ]]; then
                found=1
                break
            fi
        done

        if [[ "$found" == "0" ]]; then
            continue
        fi

        # search for new title (why does this event not contain the god damn title)
        clients=$(hyprctl clients)
        index=$(echo "$clients" | rg -ob --color never "^Window $window_id ->.*:$")
        index=$(echo "$index" | cut -d ':' -f1)
        if [[ -z "$index" ]]; then
            continue
        fi
        clients=${clients:${index}}

        # title: `title: foo bar`
        title=$(echo "$clients" | rg -ob --color never "(?<=\ttitle: ).*")
        if [[ -z "$title" ]]; then
            continue
        fi

        # is it youtube
        if [[ "$title" != *"YouTube"* ]]; then
            continue
        fi

        yt_window_id="$window_id"
        pending_title_changes=()

        # window operations
        echo "dispatch focuswindow $title" | nc -U "$write_socket" -q 0 > /dev/null
        echo "dispatch movewindow mon: 1" | nc -U "$write_socket" -q 0 > /dev/null
    fi
done
