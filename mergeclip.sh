#!/bin/bash

# Set maximum character limit
MAX_CHARS=100000

# Initialize counts
totalCharacterCount=0
totalFileCount=0
mergedContent=""

# Debug log file
DEBUG_LOG="/tmp/file_merger_debug.log"

# Temporary file for content
TEMP_FILE="/tmp/merged_content.txt"

# Function to log debug information
debug_log() {
    echo "$(date): $1" >> "$DEBUG_LOG"
}

debug_log "Script started"

# Function to check if a file is binary
is_binary() {
    file --mime-encoding "$1" | grep -q binary
}

# Function to process a single file
process_file() {
    local file="$1"

    if [ $totalCharacterCount -ge $MAX_CHARS ]; then
        debug_log "Reached character limit. Stopping scan."
        return 1
    fi

    if is_binary "$file"; then
        debug_log "Skipping binary file: $file"
        return 0
    fi

    filename=$(basename "$file")
    extension="${filename##*.}"

    fileContent="$filename\n\`\`\`$extension\n$(cat "$file")\n\`\`\`\n\n"
    fileCharCount=${#fileContent}

    if [ $((totalCharacterCount + fileCharCount)) -ge $MAX_CHARS ]; then
        debug_log "Adding this file would exceed the character limit. Stopping scan."
        return 1
    fi

    mergedContent+="$fileContent"
    totalCharacterCount=$((totalCharacterCount + fileCharCount))
    totalFileCount=$((totalFileCount + 1))
    debug_log "Processed file: $file"
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
    debug_log "No arguments provided. Exiting."
    exit 1
fi

# Process all arguments
for item in "$@"; do
    if [ -f "$item" ]; then
        process_file "$item"
    elif [ -d "$item" ]; then
        process_directory "$item"
    else
        debug_log "Error: '$item' is not a valid file or directory."
    fi
done

# Write content to temporary file
echo -n "$mergedContent" > "$TEMP_FILE"
debug_log "Content written to temporary file: $TEMP_FILE"

# Attempt to copy to clipboard using pbcopy
debug_log "Attempting to copy to clipboard using pbcopy..."
cat "$TEMP_FILE" | pbcopy
pbcopy_exit_code=$?
debug_log "pbcopy operation completed. Exit code: $pbcopy_exit_code"

# Check if pbcopy was successful
if [ $pbcopy_exit_code -ne 0 ] || [ $(pbpaste | wc -c) -eq 0 ]; then
    debug_log "pbcopy failed or clipboard is empty. Trying osascript method..."
    osascript -e "set the clipboard to (do shell script \"cat $TEMP_FILE\")"
    osascript_exit_code=$?
    debug_log "osascript clipboard operation completed. Exit code: $osascript_exit_code"

    if [ $osascript_exit_code -ne 0 ]; then
        debug_log "Error: Both pbcopy and osascript methods failed."
        osascript -e 'display alert "Error" message "Failed to copy content to clipboard. Please check the debug log for more information."'
        exit 1
    fi
fi

# Get the character count of the clipboard content
clipboardCharCount=$(pbpaste | wc -c | tr -d '[:space:]')
debug_log "Characters in clipboard: $clipboardCharCount"

# Output the result
debug_log "Total files processed: $totalFileCount"
debug_log "Total characters in processed files: $totalCharacterCount"
debug_log "Characters copied to clipboard: $clipboardCharCount"

# Display result using osascript
# osascript -e "display dialog \"$totalFileCount files merged and copied to clipboard. $totalCharacterCount characters in total.\" buttons {\"OK\"} default button \"OK\"" 2>> "$DEBUG_LOG"
# Display result in command line
echo "$totalFileCount files merged and copied to clipboard. $totalCharacterCount characters in total."

# Clean up temporary file
rm "$TEMP_FILE"
debug_log "Temporary file removed"

debug_log "Script completed"
