#!/bin/bash

# ==============================================================================
# WARNING: This script contains a password in plain text.
# This is a major security risk. Anyone who can read this file can see the
# password. It is strongly recommended to use a more secure method for
# production environments, such as prompting for a password, using SSH keys,
# or employing a configuration management tool like Ansible. This script is
# intended for educational or temporary setup purposes only.
# ==============================================================================


# --- Configuration ---
# Set the username and password for the new user.
readonly USERNAME="daniel"
readonly PASSWORD="Thunder011235813"

# --- Script Execution ---

# 1. Check if the script is being run with root privileges.
# The script needs to modify system files, which requires root access.
if [[ "$(id -u)" -ne 0 ]]; then
   echo "This script must be run as root. Please use 'sudo'." >&2
   exit 1
fi

# 2. Check if the user already exists.
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists. Exiting." >&2
    exit 1
fi

# 3. Create the user.
# -m: Creates the user's home directory (/home/daniel).
# -s /bin/bash: Sets the user's default login shell to bash.
echo "Creating user '$USERNAME'..."
useradd -m -s /bin/bash "$USERNAME"

# Check if the useradd command was successful.
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create user '$USERNAME'." >&2
    exit 1
fi

# 4. Set the password for the new user.
# We pipe the 'username:password' string to the 'chpasswd' command,
# which reads from standard input to update the password non-interactively.
echo "Setting password for user '$USERNAME'..."
echo "$USERNAME:$PASSWORD" | chpasswd

# Check if the chpasswd command was successful.
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to set the password for '$USERNAME'." >&2
    exit 1
fi

# 5. Add the user to the sudo group.
# This grants the user administrative privileges.
# -aG: Appends the user to the specified group (sudo).
echo "Adding user '$USERNAME' to the sudo group..."
usermod -aG sudo "$USERNAME"

# Check if the usermod command was successful.
if [[ $? -eq 0 ]]; then
    echo "User '$USERNAME' was created and added to the sudo group successfully."
else
    echo "Error: Failed to add user '$USERNAME' to the sudo group." >&2
    exit 1
fi

curl -d "Finished User Add Script" https://notify.thebrowns.dev/work

exit 0
