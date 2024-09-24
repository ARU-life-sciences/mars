#!/bin/bash

# Some points
# - never add `cd` to the restricted PATH, as it can be used to escape
#   the restricted environment. We add a custom function below.
# - you will have to add your own binaries to the restricted bin directory


## mars, max's restricted shell ##

# add a command line option to specify $HOME/restricted/bin location
# if not specified, use the default location (bin)
# also add a BASH path, so we know which BASH to use
while getopts ":pb:" opt; do
    case ${opt} in
        # Set the restricted directory based on the user's input
        p )
            RESTRICTED_PATH="$HOME/$OPTARG"
            ;;
        b)
            # If -b is passed, store the provided path in bash_path
            BASH_PATH="$OPTARG"
            ;;
        # Handle invalid options
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            echo "Usage: $0 [-p path to restricted bin directory]" 1>&2
            exit 1
            ;;
    esac
done

# After parsing options, shift positional parameters
shift $((OPTIND -1))

# Set the base restricted directory (where the user is jailed)
RESTRICTED_DIR="$HOME/restricted"
export RESTRICTED_DIR

# if RESTRICTED_PATH was never set, use the default value
if [ -z "$RESTRICTED_PATH" ]; then
    RESTRICTED_PATH="$RESTRICTED_DIR/bin"
fi


# Check if the BASH_PATH variable has been set
if [ ! -n "$BASH_PATH" ]; then
    BASH_PATH="/bin/bash"
    echo "Defaulting to $BASH_PATH"
fi

# Define the restricted PATH, where only specific commands are allowed
PATH="$RESTRICTED_PATH"
export PATH

# Set a restricted prompt to indicate limited functionality
PS1="mars> "
# and export it for the shell to use
export PS1

# Function to check if user tries to cd outside the allowed directory
cd() {
    # If no argument to cd, change to RESTRICTED_DIR
    if [ -z "$1" ]; then
        builtin cd "$RESTRICTED_DIR"
        return
    fi
    
    # Get the absolute path of the target directory
    TARGET_DIR=$(realpath -m "$1")
    
    # Check if the target directory is within the restricted directory
    if [[ "$TARGET_DIR" == "$RESTRICTED_DIR"* ]]; then
        builtin cd "$TARGET_DIR"
    else
        echo "Access denied: You cannot leave $RESTRICTED_DIR"
    fi
}

# Additional restrictions (optional)
# Disable environment modifications to avoid escaping restrictions
alias unset="echo 'unset is disabled'"
alias export="echo 'export is disabled'"
alias history="echo 'history is disabled'"

# Unset sensitive environment variables to avoid further changes
unset HOME
unset SHELL
unset ENV
unset BASH_ENV

# add a welcome message
echo "Welcome to Mars, the restricted shell."

# Start the restricted bash shell without profiles
exec $BASH_PATH --noprofile --norc
