# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

MYNAME="$(id -nu)"

# Kill sensitive data like gpg-agent or ssh-agent, Ubuntu default does
# no session housekeeping:
function session_terminate {
    mapfile -t GPGAGS < <(pgrep -u $(id -u) gpg-agent)
    logger -p user.notice -t 'bash_logout' "Found ${#GPGAGS[@]} gpg-agent processes to terminate."
    for proc in "${GPGAGS[@]}"; do
        kill "$proc"
    done
    mapfile -t SSHAGS < <(pgrep -u $(id -u) ssh-agent)
    logger -p user.notice -t 'bash_logout' "Found ${#SSHAGS[@]} ssh-agent processes to terminate."
    for proc in "${SSHAGS[@]}"; do
        kill "$proc"
    done
}

case "$(who | grep -c "^${MYNAME}")" in
    1)
        logger -p user.notice -t 'bash_logout' 'Only 1 session remaining, clearing up on logout.'
        session_terminate
    ;;
    0)
        logger -p user.warning -t 'bash_logout' 'Counted 0 active session, something went wrong.'
    ;;
    *)
        # not doing anything.
        true
    ;;
esac
