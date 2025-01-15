# MergeClip

[Japanese](README.ja.md)

Quick text file sharing with AI

Eliminates upload restrictions due to file extensions and the hassle of copy & paste,
efficiently conveying the contents of multiple files to AI at once.

## Overview

MergeClip is a macOS tool that quickly merges the contents of multiple text files and copies them to your Mac's clipboard in a format easily understood by AI chatbots. It significantly reduces the hassle of opening files one by one for copy & paste, supporting efficient communication with AI.

## Features

- Automatically merges multiple text files
- Automatically excludes binary files
- Automatically identifies the language based on file extensions and structures content in an AI-friendly format
- Compatible with both Mac Quick Actions (supports selection of files and folders) and shell scripts
- Processes up to 100,000 characters
- Displays the number of processed files in a dialog when executed from Finder

## Installation

### As a Quick Action

1. Download [MergeClip](https://koriym.github.io/MergeClip/MergeClip.zjp), unzip it, open it, and follow the installation instructions.

<img width="602" alt="Quick Action Installer" src="https://github.com/koriym/MergeClip/assets/529021/40c2f991-8feb-4145-b0bf-4b6c61ba1930">

(Example of Japanese screen)

### As a Shell Script

1. Download [mergeclip.sh](https://koriym.github.io/MergeClip/MergeClip.zip) and save it to an appropriate location.
2. Open Terminal and run the following commands to make the script executable:
   ```
   mv mergeclip.sh /path/to/mergeclip
   chmod +x /path/to/mergeclip
   ```

## Usage

### As a Quick Action

In Finder, select one or more target files or folders, then choose "Quick Actions > MergeClip" from the context menu. The merged content will be automatically copied to the clipboard, and a dialog will display the number of processed files.

<img width="138" alt="Quick Action" src="https://github.com/koriym/MergeClip/assets/529021/bea8eb57-c105-4504-b8ab-87d000ef3d02">

### As a Shell Script

Run the following command in Terminal:

```
/path/to/mergeclip /path/to/target/folder
```

You can also specify multiple files and folders:

```
/path/to/mergeclip file1.txt file2.php /path/to/folder1 /path/to/folder2
```

## Use Cases

1. Have AI explain the contents of a source folder:
   Process a folder containing source code with MergeClip, paste the result into an AI chat, and efficiently get an explanation of the entire codebase.

2. Translate or analyze the contents of multiple files at once:
   Use MergeClip to compile files, then ask AI to translate or analyze them all together.

## Output Format

MergeClip merges file contents in the following format. It automatically sets appropriate language tags based on file extensions:

````
Filename1.ext
```ext
File1 content
```

Filename2.py
```py
File2 content
```
````

Example:
````php
Hello.php
```php
<?php
echo 'Hello';
```
````

This format allows AI to easily understand the file types and contents, generating more accurate responses.

## Limitations

- Binary files are automatically excluded.
- MergeClip is designed for macOS only and uses the `pbcopy` command for clipboard operations.

Use MergeClip to make your communication with AI more efficient!
