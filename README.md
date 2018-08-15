# Xcode Project Renamer

**Swift script for renaming Xcode project**

It should be executed from inside root of Xcode project directory and called with two string parameters: 
**$OLD_PROJECT_NAME** & **$NEW_PROJECT_NAME**

Script goes through all the files and directories recursively, including Xcode project or workspace file and replaces all occurrences of **$OLD_PROJECT_NAME** string with **$NEW_PROJECT_NAME** string (both in each file's name and content).

## Usage

```bash
$ git clone https://github.com/appculture/xcode-project-renamer.git
  cp xcode-project-renamer/Sources/main.swift ./rename.swift
  rm -rf xcode-project-renamer
  chmod +x rename.swift

$ ./rename.swift "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"

$ rm rename.swift
```

## License
This code is released under the MIT license. See [LICENSE](LICENSE) for details.
