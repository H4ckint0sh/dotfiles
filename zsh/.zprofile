# SSH Agent Management (lazy)
ssh_agent_lazy() {
    # Start ssh-agent if not running
    pgrep -u "$USER" ssh-agent > /dev/null || eval "$(ssh-agent -s)" > ~/.ssh/agent.env

    # Load keys into ssh-agent if no identities are present
    if ssh-add -l 2>/dev/null | grep -q "The agent has no identities."; then
        echo "Loading SSH keys..."
        for key in ~/.ssh/id_*; do
            [[ -f "$key" && "$key" != *.pub ]] && ssh-add --apple-use-keychain "$key"
        done
    fi
}

# Automatically manage ssh keys 
ssh_agent_lazy
