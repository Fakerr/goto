#!/usr/bin/env bash


# Global variables
# WARNING: this is just for test. Should be changed with a not used Key.
GOTO_KEY="\C-k"               # Key binding to run the program.
COMMAND_STR=""                # Temporary command line holding the char based tree.
COMMAND_POINT=""              # Position if selected char.
INITIAL_READLINE_LINE=""      # Initial command line string.
INITIAL_READLINE_POINT=""     # Initial command line point.
CHAR_NODES=()                 # Nodes of the tree's first level.
CHARS=( {a..z} )
EC="$(echo -e '\e')"          # escape key
declare -A node_position

# Set colors
RED=$(tput setaf 1)
BLUE=$(tput setaf 2)
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
    READLINE_LINE="$1"
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

# Init tree's nodes
init_tree_nodes() {
    for i in "${CHARS[@]}"
    do
	CHAR_NODES+=("$REVERSE$BLUE$i$NORMAL")
    done
}

# For each user input, update COMMAND_STR with the new char based tree.
generate_tree() {
    key="$1"
    index=0
    tmp_cmd="$INITIAL_READLINE_LINE"
    tmp_ind=0
    node_position=()
    for (( i=0; i<${#COMMAND_STR}; i++ )); do
	if [[ "${COMMAND_STR:$i:1}" == "$key" ]]; then
	    NODE=${CHAR_NODES[$index]}
	    tmp_cmd="${tmp_cmd:0:$tmp_ind}$NODE${tmp_cmd:$(( tmp_ind + 1 ))}"
	    tmp_ind=$(( tmp_ind + ${#NODE} - 1 ))

	    node_label=${CHARS[$index]}
	    node_position["$node_label"]="$i"

	    index=$(( index + 1 ))
	fi
	tmp_ind=$(( tmp_ind + 1 ))
    done
    COMMAND_STR="$tmp_cmd"
}

# read user input
read_user_input() {
    stop=false     # if equal to true, exit while loop.
    save_and_clear # save cursor postion and clear screen
    alert="info"
    while ! $stop
    do
    	display_alert "$alert"
    	echo "$COMMAND_STR"
    	read -sn 1 key
	if [[ "$key" =~ [A-Za-z0-9_!@#$%()+-={}:\;?\'|,.\<\>] ]]; then
	    generate_tree "$key"
	    restore_and_clear
	    
	    display_alert "info"
	    echo "$COMMAND_STR"
	    read -sn 1 key2
	    
	    COMMAND_POINT="${node_position["$key2"]}"
	    restore_and_clear
	    stop=true
	elif [[ "$key" == "$EC" ]]; then
	    COMMAND_POINT="$INITIAL_READLINE_POINT"
	    restore_and_clear
	    stop=true
	else
	    alert="error"
    	    restore_and_clear
	fi
    done
}

# echo alert message
display_alert() {
    if [[ $1 == "info" ]]; then
	echo -n "$REVERSE"
	echo -n "$YELLOW"
	echo "goto:"
	echo -n "$NORMAL"
    elif [[ $1 == "error" ]]; then
	echo -n "$REVERSE"
	echo -n "$RED"
	echo "ERROR: non valid character"
	echo -n "$NORMAL"
    fi
} 

# main function
main() {
    # Initialization
    init_tree_nodes
    save_initial_readline
    init_temporary_cmd "$INITIAL_READLINE_LINE"

    # Clear readline and wait for user input
    clear_readline_line
    read_user_input

    # Update READLINE
    update_readline_line "$INITIAL_READLINE_LINE"
    update_readline_point "$COMMAND_POINT"
}

