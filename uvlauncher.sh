#!/bin/bash

zenity --question --title "Disclaimer" \
--width=500 --height=200 \
--text="This program offers an easy way to undervolt a Steam Deck as safely as possible and without entering the BIOS or disabling read-only using RyzenAdj and systemd targets based on Chris Down's guide.

As with any undervolt, exercise caution. While this project greatly reduces the risk of bricking your deck, it does not in any way guarantee you won't damage your hardware. Use at your own risk."

if [[ $? -eq 0 ]]; then
    # Prompt user for password
    password=$(zenity --password --title "Enter Password" --text "Please enter your password:")

    # Check if password is not empty
    if [[ -n "$password" ]]; then
        # Use 'sudo' with the provided password to run the script
        echo "$password" | sudo -S ./uvlauncher.sh
    else
        zenity --info --title "Password Entry" --text "No password entered. Exiting..."
    fi

    # Display the main menu using zenity
    choice=$(zenity --list --title "Steam Deck Undervolt Software" --text "Choose an option:" \
                   --width=400 --height=300 \
                   --column="Option" --column="Description" \
                   "Experimental Undervolt On" "Enable experimental undervolt" \
                   "Edit Experimental UV Values" "Edit experimental undervolt values" \
                   "Undervolt On" "Enable undervolt" \
                   "Edit UV Values" "Edit undervolt values" \
                   "Undervolt OFF" "Disable undervolt" \
                   "Exit" "Exit the program")

    # Process the selected option
    case "$choice" in
        "Experimental Undervolt On")
            zenity --info --title "Option Selected" --text "Enabling experimental undervolt..."
            /home/deck/.local/bin/experimental.sh
            ;;
        "Edit Experimental UV Values")
            new_values=$(zenity --entry --title "Edit experimental undervolt values" --text "Enter new experimental undervolt values (Default is -15)")
            if [[ -n "$new_values" ]]; then
                zenity --info --title "Option Selected" --text "New values: $new_values"
                # Replace line 24 in testuv.sh with new_values
                sed -i "24s/.*/        \/home\/deck\/.local\/bin\/ryzenadj --set-coall=\"$new_values\"/" /home/deck/.local/bin/testuv.sh
                zenity --info --title "Line Replaced" --text "Line 24 in testuv.sh replaced with: /home/deck/.local/bin/ryzenadj --set-coall=\"$new_values\""
            else
                zenity --warning --title "Warning" --text "No new values entered."
            fi
            ;;
        "Undervolt On")
            zenity --info --title "Option Selected" --text "Enabling undervolt..."
            /home/deck/.local/bin/on.sh
            ;;
        "Edit UV Values")
            zenity --info --title "Option Selected" --text "Edit undervolt values selected."
            # Add your commands for editing undervolt values here
            ;;
        "Undervolt OFF")
            zenity --info --title "Option Selected" --text "Disabling undervolt..."
            /home/deck/.local/bin/off.sh
            ;;
        "Exit")
            zenity --info --title "Exiting" --text "Exiting the program."
            ;;
        *)
            zenity --error --title "Error" --text "Invalid option."
            ;;
    esac
else
    zenity --info --title "Exiting" --text "Exiting the program."
fi

