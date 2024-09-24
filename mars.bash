## mars, max's restricted shell ##

# Some points
# - never add `cd` to the restricted PATH, as it can be used to escape
#   the restricted environment. We add a custom function below.
# - you will have to add your own binaries to the restricted bin directory

# print usage
usage() {
    echo "mars: Max's restricted shell"
    echo ""
    echo "Usage: $0 [-p <RESTRICTED_PATH>] [-b <BASH_PATH>] [-h]" 
    echo "Options:"
    echo "  -p               Path to the restricted directory."
    echo "  -b <BASH_PATH>   Specify the BASH executable path."
    echo "  -h               Display this help message."
    echo ""
    echo "For Mac's only. Not tested on Linux."
    echo ""
    echo ""
    echo "Add your own binaries to the restricted dir, for example:"
    echo ""
    echo "mkdir -p /home/user/restricted/bin
cp /bin/ls /home/user/restricted/bin/
cp /bin/echo /home/user/restricted/bin/
"
    exit 0
}

# add a command line option to specify $HOME/restricted/bin location
# if not specified, use the default location (bin)
# also add a BASH path, so we know which BASH to use
while getopts ":p:b:h" opt; do
    case ${opt} in
        # Set the restricted directory based on the user's input
        p)
            RESTRICTED_PATH="$OPTARG"
            ;;
        b)
            # If -b is passed, store the provided path in bash_path
            BASH_PATH="$OPTARG"
            ;;
        # Display usage
        h)
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." 1>&2
            echo ""
            usage
            exit 1
            ;;
        # Handle invalid options
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            echo ""
            usage
            exit 1
            ;;
    esac
done

# After parsing options, shift positional parameters
shift $((OPTIND -1))

# if no restricted path is set, default to $HOME/restricted
if [ ! -n "$RESTRICTED_PATH" ]; then
    RESTRICTED_PATH="$HOME/restricted"
    DEFAULT_RESTRICTED_MESSAGE="Defaulting to $RESTRICTED_PATH"
fi

# Set the base restricted directory (where the user is jailed)
RESTRICTED_DIR=$RESTRICTED_PATH
# export RESTRICTED_DIR

RESTRICTED_BIN_PATH="$RESTRICTED_DIR/bin"

# Check if the BASH_PATH variable has been set
if [ ! -n "$BASH_PATH" ]; then
    BASH_PATH="/bin/bash"
    DEFAULT_BASH_MESSAGE="Defaulting to $BASH_PATH"
fi

# Define the restricted PATH, where only specific commands are allowed
PATH="$RESTRICTED_BIN_PATH"
export PATH

# Set a restricted prompt to indicate limited functionality
PS1="mars> "
# and export it for the shell to use
export PS1

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
echo "$DEFAULT_BASH_MESSAGE"
echo "Restricted directory: $RESTRICTED_DIR"

exec "$BASH_PATH" --noprofile --norc --restricted
