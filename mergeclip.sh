#!/bin/bash

# Debug log file
DEBUG_LOG="/tmp/file_merger_debug.log"
# Temporary file for content
TEMP_FILE="/tmp/merged_content.txt"

# Function to log debug information
debug_log() {
    echo "$(date): $1" >> "$DEBUG_LOG"
}

estimate_tokens() {
    local text="$1"
    local char_count=${#text}

    # 文字数からトークン数を推定（比率 0.245）
    local estimated_tokens=$(( (char_count * 245) / 1000 ))

    # 最小トークン数の保証
    if [ "$estimated_tokens" -lt 1 ]; then
        estimated_tokens=1
    fi

    echo "$estimated_tokens"
}

format_k_unit() {
    local num="$1"
    if [ -n "$num" ] && [ "$num" -ge 1000 ]; then
        echo "$((num / 1000)).$((num % 1000 / 100))K"
    else
        echo "$num"
    fi
}

# Function to check if a file is binary
is_binary() {
    file --mime-encoding "$1" | grep -q binary
}

# Initialize counts
totalCharacterCount=0
totalFileCount=0
mergedContent=""

# Function to process a single file
process_file() {
    local file="$1"

    if is_binary "$file"; then
        debug_log "Skipping binary file: $file"
        return 0
    fi

    filename=$(basename "$file")
    extension="${filename##*.}"
    fileContent="$filename\n\`\`\`$extension\n$(cat "$file")\n\`\`\`\n\n"
    fileCharCount=${#fileContent}

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
        process_file "$file"
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

# Calculate total tokens
totalTokens=$(estimate_tokens "$mergedContent")
formattedTokens=$(format_k_unit $totalTokens)
formattedChars=$(format_k_unit $totalCharacterCount)

# Write content to temporary file
echo -n "$mergedContent" > "$TEMP_FILE"
debug_log "Content written to temporary file: $TEMP_FILE"

# Attempt to copy to clipboard using pbcopy
debug_log "Attempting to copy to clipboard using pbcopy..."
cat "$TEMP_FILE" | pbcopy
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy to clipboard" >&2
    exit 1
fi

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

# Get the clipboard content stats
clipboardContent=$(pbpaste)
clipboardCharCount=${#clipboardContent}
clipboardTokens=$(estimate_tokens "$clipboardContent")
formattedClipboardTokens=$(format_k_unit $clipboardTokens)

# Log details
debug_log "Files processed: $totalFileCount"
debug_log "Total characters: $totalCharacterCount ($formattedChars)"
debug_log "Estimated tokens: $totalTokens ($formattedTokens)"
debug_log "Characters in clipboard: $clipboardCharCount"
debug_log "Estimated tokens in clipboard: $clipboardTokens"

# Display result using osascript
osascript -e "display dialog \"$totalFileCount files merged and copied to clipboard.\nCharacters: $formattedChars\nEst. tokens: $formattedTokens\" buttons {\"OK\"} default button \"OK\"" 2>> "$DEBUG_LOG"

# Display result in command line
echo "Summary:"
echo "- Files processed: $totalFileCount"
echo "- Characters: $formattedChars"
echo "- Est. tokens: $formattedTokens"
echo "Content copied to clipboard successfully."

# Clean up temporary file
rm "$TEMP_FILE"
debug_log "Temporary file removed"
debug_log "Script completed"
