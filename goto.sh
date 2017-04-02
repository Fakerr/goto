#!/usr/bin/env bash


# Key binding to run the program. (default \C-k)
goto_key="${GOTO_KEY:-\C-k}" 

# Global variables
VERSION="1.0.0"
COMMAND_STR=""                # Temporary command line holding the char based tree.
COMMAND_POINT=0               # Selected char position.
INITIAL_READLINE_LINE=""      # Initial command line string.
INITIAL_READLINE_POINT=0      # Initial command line point.
NEXT_LEVEL=false              # True if another level is accessible
CHAR_NODES=()                 # Nodes of the tree's first level.
CHARS=( {a..z} )
EC="$(echo -e '\e')"          # Escape key
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
bind '"'"$goto_key"'":"\key1\key2"'   

# Save the initial command line.
save_initial_readline() {
    INITIAL_READLINE_LINE="$READLINE_LINE"
    INITIAL_READLINE_POINT="$READLINE_POINT"
}

# Init temporary command line (temporary READLINE_LINE)
set_temporary_cmd() {
    COMMAND_STR="$1"
}

# Set index starting from where the tree will be generated
set_start_index() {
    start_index="$1"
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
    key=$1
    c=$start_index
    upper_key="${key^^}"
    lower_key="${key,,}"
    index=0
    tmp_cmd="$INITIAL_READLINE_LINE"
    tmp_ind=$start_index
    node_position=()
    NEXT_LEVEL=false
    for (( i=c; i<${#COMMAND_STR}; i++ )); do
	char="${COMMAND_STR:$i:1}"
	if [[ "$char" == "$upper_key" ]] || [[ "$char" == "$lower_key" ]]; then
	    if [[ $index -lt ${#CHARS[@]} ]]; then
		NODE=${CHAR_NODES[$index]}
		tmp_cmd="${tmp_cmd:0:$tmp_ind}$NODE${tmp_cmd:$(( tmp_ind + 1 ))}"
		tmp_ind=$(( tmp_ind + ${#NODE} - 1 ))
		node_label=${CHARS[$index]}
		node_position["$node_label"]="$i"
		index=$(( index + 1 ))
	    else
		NEXT_LEVEL=true
		NODE="${REVERSE}${RED}?${NORMAL}"
		tmp_cmd="${tmp_cmd:0:$tmp_ind}$NODE${tmp_cmd:$(( tmp_ind + 1 ))}"
		tmp_ind=$(( tmp_ind + ${#NODE} - 1 ))
		index=$(( index + 1 ))
	    fi
	fi
	tmp_ind=$(( tmp_ind + 1 ))
    done
    set_temporary_cmd "$tmp_cmd"
}

navigate_tree() {
    goto="$1"
    end=false
    while ! $end
    do
    	echo "$COMMAND_STR"
	read -sn 1 key2
	if [[ "$key2" == "?" ]] && [[ $NEXT_LEVEL = true ]]; then
    	    set_temporary_cmd "$INITIAL_READLINE_LINE"
	    set_start_index $(( ${node_position["z"]} + 1 ))
    	    generate_tree "$goto" 
    	    restore_and_clear
    	    display_alert "info"
	elif [[ "$key2" =~ [a-z] ]]; then
    	    COMMAND_POINT="${node_position["$key2"]}"
    	    restore_and_clear
	    end=true
    	    stop=true
	elif [[ "$key2" == "$EC" ]]; then
	    COMMAND_POINT="$INITIAL_READLINE_POINT"
	    restore_and_clear
	    end=true
	    stop=true
	else
	    restore_and_clear
    	    display_alert "error"
	fi
    done
}

# read character
read_character() {
    stop=false     # if equal to true, exit while loop.
    save_and_clear # save cursor postion and clear screen
    display_alert "info"
    while ! $stop
    do
    	echo "$COMMAND_STR"
    	read -sn 1 key
	if [[ "$key" =~ [A-Za-z0-9_!@#$%()+-={}:\;?\'|,.\<\>] ]]; then
	    generate_tree "$key" # generate char based tree
	    restore_and_clear
	    first_elt=${node_position["a"]} 
	    if [[ -z "$first_elt" ]]; then
		display_alert "error" 
	    else
		display_alert "info" 
		navigate_tree "$key"
	    fi
	elif [[ "$key" == "$EC" ]]; then
	    COMMAND_POINT="$INITIAL_READLINE_POINT"
	    restore_and_clear
	    stop=true
	else
    	    restore_and_clear
	    display_alert "error" 
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
	echo "ERROR: invalid character"
	echo -n "$NORMAL"
    fi
} 

# main function
main() {
    # Initialization
    set_start_index 0
    init_tree_nodes
    save_initial_readline
    set_temporary_cmd "$INITIAL_READLINE_LINE"

    # Clear readline and wait for user input
    clear_readline_line
    read_character

    # Update READLINE
    update_readline_line "$INITIAL_READLINE_LINE"
    update_readline_point "$COMMAND_POINT"
}

