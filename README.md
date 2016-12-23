# Xcode Project Renamer #

**Shell script written in Swift 3 which does the renaming of Xcode project.**

It is optimized to work with the standard projects but it can also be used for any Xcode projects (maybe with some minor tweaks).

It should be executed from inside the root of project directory and called with two string parameters: 
**$OLD_PROJECT_NAME** & **$NEW_PROJECT_NAME**

Script goes through all the files and directories, including Xcode Project File and replaces all occurrences of **$OLD_PROJECT_NAME** string with a **$NEW_PROJECT_NAME** string.

## Usage ##

`git clone https://bitbucket.org/appculture/xcodeprojectrenamer.git` (good luck with [that](https://bitbucket.org/site/master/issues/5232/authentication-failed-for-any-repo#comment-33134847))

`cp xcodeprojectrenamer/XcodeProjectRenamer/main.swift ./rename.swift`

`rm -rf xcodeprojectrenamer`

`chmod +x rename.swift`

`./rename.swift "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"`

`rm rename.swift`