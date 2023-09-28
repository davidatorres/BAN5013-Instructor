#!/bin/zsh

# Specify the directory path
DIRECTORY="../Images/"

# Iterate over files in the directory
for file in "${DIRECTORY}"/*; do
    # Check if the current item is a file
    if [[ -f "${file}" ]]; then
        # Echo the name of the file
        echo "$DIRECTORY$(basename "${file}")"
        az storage blob upload \
            --auth-mode login \
            --account-name ban5013st \
            --container-name images \
            --file "$DIRECTORY$(basename "${file}")" \
            --name "$(basename "${file}")" \
            --overwrite true \
            --content-cache "max-age=90"
    fi
done