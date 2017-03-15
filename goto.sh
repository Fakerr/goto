#!/usr/bin/env bash


# Global variables
# WARNING: this is just for test. Should be changed with a not used Key.
GOTO_KEY="\C-k"               # Key binding to run the program.
INITIAL_READLINE_LINE=""      # Initial command line string.
INITIAL_READLINE_POINT=""     # Initial command line point.

# Key bindings. Before executing the main function, place the cursor at the begeninng of the command line (\key1). 
bind '"\key1":"\C-a"' 
bind -x '"\key2":"main"'
bind '"'"$GOTO_KEY"'":"\key1\key2"'   

# Save the initial command line.
save_initial_command() {
    INITIAL_READLINE_LINE="$READLINE_LINE"
    INITIAL_READLINE_POINT="$READLINE_POINT"
}

# Clear READLINE_LINE from terminal.
clear_readline_line() {
    READLINE_LINE=""
}

# Update READLINE_LINE. This will print a new command in the terminal.
update_readline_line() {
    READLINE_LINE="$1"
}

# Update READLINE_POINT. This will place the cursor at the specified place.
update_readline_point() {
    READLINE_POINT="$1"
}

read_user_input() {
    stop=false
    tput sc
    tput ed
    while ! $stop
    do
	echo "$COMMAND_STR"
	read -sn 1 key
	case "$key" in
	    "a")
		COMMAND_STR="$COMMAND_STR walid"
		tput rc
		tput ed
		;;
	    "b")
		COMMAND_STR="$COMMAND_STR Fakerr"
		tput rc
		tput ed	
		;;
	    "q")
		stop=true
		tput rc
		tput ed	
		;;
	    * )
		tput rc
		tput ed	
	esac
    done
}

# main function
main() {
    save_initial_command
    COMMAND_STR="$READLINE_LINE"
    clear_readline_line
    read_user_input
    update_readline_line "$COMMAND_STR"
    update_readline_point 50
}

