# Function to check BW_SESSION and prompt for unlock
function bw_unlock_prompt() {
    # Only proceed if the session is not set
    if [[ -z "$BW_SESSION" ]]; then
        # Minimal prompt using Zsh's single-key read. The prompt is "Unlock vault?: "
        read -q "choice?Unlock vault?: "

        # Check the exit status ($?) which is 0 only if 'y' or 'Y' was pressed
        if [[ $? -eq 0 ]]; then
            # Move to a new line after the prompt
            echo

            # Execute the unlock command, which will interactively prompt for the password
            export BW_SESSION="$(bw unlock --raw)"
        fi
    fi
}

# Run this function every time a new interactive Zsh session starts
bw_unlock_prompt
