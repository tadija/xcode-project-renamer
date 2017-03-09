# Xcode Project Renamer

**Swift script for renaming Xcode project**

It is currently optimized to work with our template project but it can also be used with any Xcode project (with some minor tweaks).

It should be executed from inside the root of project directory and called with two string parameters: 
**$OLD_PROJECT_NAME** & **$NEW_PROJECT_NAME**

Script goes through all the files and directories, including Xcode project file and replaces all occurrences of **$OLD_PROJECT_NAME** string with **$NEW_PROJECT_NAME** string.

## Use

`git clone https://github.com/appculture/xcode-project-renamer.git`

`cp xcode-project-renamer/Sources/main.swift ./rename.swift`

`rm -rf xcode-project-renamer`

`chmod +x rename.swift`

`./rename.swift "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"`

`rm rename.swift`

## License
This code is released under the MIT license. See [LICENSE](LICENSE) for details.
