#!/usr/bin/swift

//
//  main.swift
//  XcodeProjectRenamer
//
//  Created by Marko Tadic on 8/1/16.
//  Copyright © 2016 appculture. All rights reserved.
//

import Foundation

class XcodeProjectRenamer: NSObject {
    
    // MARK: - Constants
    
    struct Color {
        static let Black = "\u{001B}[0;30m"
        static let Red = "\u{001B}[0;31m"
        static let Green = "\u{001B}[0;32m"
        static let Yellow = "\u{001B}[0;33m"
        static let Blue = "\u{001B}[0;34m"
        static let Magenta = "\u{001B}[0;35m"
        static let Cyan = "\u{001B}[0;36m"
        static let White = "\u{001B}[0;37m"
    }
    
    // MARK: - Properties
    
    let fileManager = FileManager.default
    
    let oldName: String
    let newName: String
    
    // MARK: - Init
    
    init(oldName: String, newName: String) {
        self.oldName = oldName
        self.newName = newName
    }
    
    // MARK: - API
    
    func run() {
        print("\n\(Color.Green)------------------------------------------")
        print("\(Color.Green)Rename Xcode Project from [\(oldName)] to [\(newName)]")
        print("\(Color.Green)Current Path: \(fileManager.currentDirectoryPath)")
        print("\(Color.Green)------------------------------------------")
        
        handleUnitTests()
        handleUITests()
        handleMainTarget()
        handleProjectFile()
        
        print("\n\(Color.Green)------------------------------------------")
        print("\(Color.Green)Xcode Project Rename Finished!")
        print("\(Color.Green)------------------------------------------\n")
    }
    
    // MARK: - Helpers
    
    private func handleUnitTests() {
        print("\n\(Color.Magenta)--- [Unit Tests]")
        enumerateCurrentPath(appendingPathComponent: "\(oldName) Tests")
    }
    
    private func handleUITests() {
        print("\n\(Color.Magenta)--- [UI Tests]")
        enumerateCurrentPath(appendingPathComponent: "\(oldName) UITests")
    }
    
    private func handleMainTarget() {
        print("\n\(Color.Magenta)--- [Main Target]")
        enumerateCurrentPath(appendingPathComponent: oldName)
    }
    
    private func handleProjectFile() {
        print("\n\(Color.Magenta)--- [Project File]")
        enumerateCurrentPath(appendingPathComponent: "\(oldName).xcodeproj")
    }
    
    private func enumerateCurrentPath(appendingPathComponent pathComponent: String) {
        let currentPath = fileManager.currentDirectoryPath
        let path = currentPath.appending("/\(pathComponent)/")
        
        enumerateDirectory(atPath: path)
        renameItem(atPath: path)
    }
    
    private func enumerateDirectory(atPath path: String) {
        print("\n\(Color.Yellow)- DIRECTORY: \(path)")
        
        let enumerator = fileManager.enumerator(atPath: path)
        
        while let element = enumerator?.nextObject() as? String {
            if !shouldSkip(element) {
                let itemPath = path.appending(element)
                
                var isDir: ObjCBool = false
                if fileManager.fileExists(atPath: itemPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        updateContentsOfFile(atPath: itemPath)
                    }
                }

                renameItem(atPath: itemPath)
            }
        }
    }
    
    private func shouldSkip(_ element: String) -> Bool {
        guard !element.contains(".DS_Store") else { return true }
        
        let fileExtension = URL(fileURLWithPath: element).pathExtension
        switch fileExtension {
        case "appiconset", "json", "png", "xcuserstate":
            return true
        default:
            return false
        }
    }
    
    private func updateContentsOfFile(atPath path: String) {
        print("\n\(Color.White)UPDATE ITEM: \(path)")
        
        do {
            let oldContent = try String(contentsOfFile: path, encoding: .utf8)
            if oldContent.contains(oldName) {
                print("\(Color.Blue)UPDATE: \(path)")
                let newContent = oldContent.replacingOccurrences(of: oldName, with: newName)
                try newContent.write(toFile: path, atomically: true, encoding: .utf8)
            } else {
                print("\(Color.White)SKIP: \(path)")
            }
            
        } catch {
            print("\(Color.Red)\(error)\n")
        }
    }
    
    private func renameItem(atPath path: String) {
        print("\n\(Color.White)RENAME ITEM: \(path)")
        
        do {
            let oldItemName = URL(fileURLWithPath: path).lastPathComponent
            if oldItemName.contains(oldName) {
                let newItemName = oldItemName.replacingOccurrences(of: oldName, with: newName)
                print("\(Color.Blue)RENAME: \(oldItemName) -> \(newItemName)")
                
                let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
                let newPath = directoryURL.appendingPathComponent(newItemName).path
                
                try fileManager.moveItem(atPath: path, toPath: newPath)
            } else {
                print("\(Color.White)SKIP: \(path)")
            }
        } catch {
            print("\(Color.Red)\(error)")
        }
    }
    
}

let arguments = Process.arguments
if arguments.count == 3 {
    let oldName = arguments[1]
    let newName = arguments[2].replacingOccurrences(of: " ", with: "")
    let xpr = XcodeProjectRenamer(oldName: arguments[1], newName: newName)
    xpr.run()
} else {
    print("\(XcodeProjectRenamer.Color.Red)Invalid number of arguments! Expected OLD and NEW project name.")
}
