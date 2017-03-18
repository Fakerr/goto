#!/usr/bin/env bash


# Global variables
# WARNING: this is just for test. Should be changed with a not used Key.
GOTO_KEY="\C-k"               # Key binding to run the program.
COMMAND_STR=""                # Temporary command line holding the char based tree.
INITIAL_READLINE_LINE=""      # Initial command line string.
INITIAL_READLINE_POINT=""     # Initial command line point.

# Set colors
GREEN=$(tput setaf 4)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)
REVERSE=$(tput rev)

# Key bindings. Before executing the main function, place the cursor at the begeninng of the command line (\key1). 
bind '"\key1":"\C-a"' 
bind -x '"\key2":"main"'
bind '"'"$GOTO_KEY"'":"\key1\key2"'   

# Save the initial command line.
save_initial_readline() {
    INITIAL_READLINE_LINE="$READLINE_LINE"
    INITIAL_READLINE_POINT="$READLINE_POINT"
}

# Init temporary command line (temporary READLINE_LINE)
init_temporary_cmd() {
    COMMAND_STR="$1"
}

# Clear READLINE_LINE from terminal.
clear_readline_line() {
    READLINE_LINE=""
}

# Update READLINE_LINE. This will print a new command in the terminal.
update_readline_line() {
    READLINE_LINE="$COMMAND_STR"
}

# Update READLINE_POINT. This will place the cursor at the specified place.
update_readline_point() {
    READLINE_POINT="$1"
}

# Save cursor and clear
save_and_clear() {
    tput sc # Save cursor position
    tput ed # Clear screen
}

# Restore saved cursor position and clear
restore_and_clear() {
    tput rc # Restore cursor position
    tput ed # Clear screen
}

# For each user input, update COMMAND_STR with the new char based tree.
update_command() {
    COMMAND_STR="$COMMAND_STR walid"
}

read_user_input() {
    stop=false # if equal to true, stop read and exit while loop.
    save_and_clear
    while ! $stop
    do
	display_info
	echo "$COMMAND_STR"
	read -sn 1 key
	case "$key" in
	    "a")
		update_command
		restore_and_clear
		;;
	    "q")
		stop=true
		restore_and_clear
		;;
	    * )
		restore_and_clear
	esac
    done
}

# echo info message
display_info() {
    echo -n "$REVERSE"
    echo -n "$YELLOW"
    echo "goto: "
    echo -n "$NORMAL"
} 

# main function
main() {
    save_initial_readline # Save the initial command to restore later
    init_temporary_cmd "$INITIAL_READLINE_LINE"
    clear_readline_line
    read_user_input
    update_readline_line
    update_readline_point 50
}

