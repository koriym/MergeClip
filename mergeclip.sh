#!/bin/bash

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

# Function to process a single file
process_file() {
    local file="$1"

    if [ $totalCharacterCount -ge $MAX_CHARS ]; then
        echo "Reached character limit. Stopping scan."
        return 1
    fi

    if is_binary "$file"; then
        echo "Skipping binary file: $file"
        return 0
    fi

    filename=$(basename "$file")
    extension="${filename##*.}"

    fileContent="$filename\n\`\`\`$extension\n$(cat "$file")\n\`\`\`\n\n"
    fileCharCount=${#fileContent}

    if [ $((totalCharacterCount + fileCharCount)) -ge $MAX_CHARS ]; then
        echo "Adding this file would exceed the character limit. Stopping scan."
        return 1
    fi

    mergedContent+="$fileContent"
    totalCharacterCount=$((totalCharacterCount + fileCharCount))
    totalFileCount=$((totalFileCount + 1))
    return 0
}

# Function to process a directory
process_directory() {
    local directory="$1"

    while IFS= read -r -d '' file; do
        process_file "$file" || break
    done < <(find "$directory" -type f ! -name '.*' -print0)
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> <file2> ... <directory1> <directory2> ..."
    exit 1
fi

# Process all arguments
for item in "$@"; do
    if [ -f "$item" ]; then
        process_file "$item"
    elif [ -d "$item" ]; then
        process_directory "$item"
    else
        echo "Error: '$item' is not a valid file or directory."
    fi
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
