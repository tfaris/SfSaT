# Command to properly clear the terminal when running in ConEmu (login session only)
# found here:
# http://superuser.com/questions/122911/what-commands-can-i-use-to-reset-and-clear-my-terminal
function clear(){
    echo -e '\0033\0143'
}

# Fix muscle memory of using windows 'cls' command
function cls(){
    clear
}
