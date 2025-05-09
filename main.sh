#!/bin/bash

# Userinput for group name
read -p "Enter group name: " groupname

# Check if the group name already exists
if grep -q "^$groupname:" /etc/group; then
    echo "Error: Group name $groupname already exists. Please try another."
else
    if [[ "$(id -u)" -eq 0 ]]; then
        groupadd "$groupname"
        echo "Group $groupname has been created."
    else
        echo "Error: Check your permission or you may not be a root user."
    fi
fi

# Userinput for user name
read -p "Enter user name: " username

# Check if the user name already exists
if grep -q "^$username:" /etc/passwd; then
    echo "Error: User name already exists. Please try another name."
else
    if [[ "$(id -u)" -eq 0 ]]; then
        useradd -G "$groupname" "$username"
        echo "User $username has been created and added to the group $groupname."
    else
        echo "Error: Check your permission or you may not be a root user."
    fi
fi


# setting password for user
read -p "Enter new Password for $username: " password

echo "$username:$password" | chpasswd
echo "Password has been updated for user $username."

# Check the new created user is the new created group's member or not
if groups "$username" | grep -w "$groupname"; then
        echo "$username is in $groupname"
else
        echo "$username is not in $groupname"
fi


# creating dir as the new user name created at root location
if [[ "$(id -u)" -eq 0 ]]; then
        dir_name="$username"
        mkdir "/$dir_name"
        echo "The Directory '/$dir_name' is created"
        chown  "$username:$groupname" "/$dir_name"     # change ownership of dir_name with main use and primary group
        chmod 1770 "/$dir_name"    #-- Full control to user and group created and also Stiky bit permission
        ls -ld "/$dir_name"
else
        echo "Error: Check your permission or you may not be root user."
fi
