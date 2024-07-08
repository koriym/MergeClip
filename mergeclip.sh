#!/bin/bash

# Get the selected directory from command line argument
directory="$1"

# Check if directory is provided
if [ -z "$directory" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Check if directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Set maximum character limit
MAX_CHARS=100000

# Initialize counts
totalCharacterCount=0
totalFileCount=0
mergedContent=""

# Function to check if a file is binary
is_binary() {
    file --mime-encoding "$1" | grep -q binary
}

# Recursively search for files, excluding hidden and binary files, and merge them
find "$directory" -type f ! -name '.*' | while read -r file; do
    if [ $totalCharacterCount -ge $MAX_CHARS ]; then
        echo "Reached character limit. Stopping scan."
        break
    fi

    if is_binary "$file"; then
        echo "Skipping binary file: $file"
        continue
    fi

    filename=$(basename "$file")
    extension="${filename##*.}"

    fileContent="$filename\n\`\`\`$extension\n$(cat "$file")\n\`\`\`\n\n"
    fileCharCount=${#fileContent}

    if [ $((totalCharacterCount + fileCharCount)) -ge $MAX_CHARS ]; then
        echo "Adding this file would exceed the character limit. Stopping scan."
        break
    fi

    mergedContent+="$fileContent"
    totalCharacterCount=$((totalCharacterCount + fileCharCount))
    totalFileCount=$((totalFileCount + 1))
done

# Copy to clipboard using pbcopy
echo -e "$mergedContent" | pbcopy

# Get the character count of the clipboard content
clipboardCharCount=$(pbpaste | wc -m)

# Output the result
echo "Total files processed: $totalFileCount"
echo "Total characters in processed files: $totalCharacterCount"
echo "Characters copied to clipboard: $clipboardCharCount"
echo "Merged content has been copied to the clipboard."
