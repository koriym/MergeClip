# MergeClip

Want to share multiple file contents with AI? Tired of endless copy-pasting? Use MergeClip to convey it all at once!

## Overview

MergeClip is a macOS tool that quickly merges the contents of multiple text files and copies them to your Mac's clipboard in a format easily understood by AI chatbots. It significantly reduces the hassle of opening files one by one for copy & paste, supporting smooth communication with AI.

## Features

- Automatically merges multiple text files
- Automatically excludes binary files
- Formats content in an AI-friendly structure
- Compatible with both Mac folder actions and shell scripts
- Processes up to 100,000 characters

## Installation

### As a Folder Action

1. Download MergeClip, open it, and follow the installation instructions.

### As a Shell Script

1. Download mergeclip.sh and save it to a suitable location.
2. Open Terminal and run the following commands to make the script executable:
   ```
   mv mergeclip.sh /path/to/mergeclip
   chmod +x /path/to/mergeclip
   ```

## Usage

### As a Folder Action

Simply select Quick Actions > MergeClip from the folder's context menu, and the merged content will be automatically copied to your clipboard.

### As a Shell Script

Run the following command in Terminal:

```
/path/to/mergeclip /path/to/target/folder
```

## Use Cases

1. Explain multiple files of a programming project to AI:
   Process your project folder with MergeClip, paste the result into an AI chat, and easily get an explanation of the entire project.

2. Translate or analyze multiple file contents at once:
   Use MergeClip to compile files, then ask AI to translate or analyze them all together.

## Output Format

MergeClip merges file contents in the following format:

```
Filename1
```language
File content
```

Filename2
```language
File content
```

This format allows AI to easily understand the file types and contents, generating more accurate responses.

## Limitations

- Processes up to 100,000 characters. Processing stops if this limit is exceeded.
- Binary files are automatically excluded.
- MergeClip is designed for macOS only and uses the `pbcopy` command for clipboard operations.

---

Use MergeClip to make your communication with AI more efficient, stress-free, and enjoyable!
