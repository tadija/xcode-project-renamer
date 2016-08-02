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
    
    // MARK: - Properties
    
    let fileManager = FileManager.default
    
    let oldName: String
    let newName: String
    
    // MARK: - Init
    
    init(oldName: String, newName: String) {
        self.oldName = oldName
        self.newName = newName
        
        print("Rename Xcode Project from [\(oldName)] to [\(newName)]")
        print("Current Path: \(fileManager.currentDirectoryPath)")
    }
    
    // MARK: - API
    
    func renameUnitTests() {
        enumerateCurrentPath(appendingPathComponent: "\(oldName) Tests")
    }
    
    func renameUITests() {
        enumerateCurrentPath(appendingPathComponent: "\(oldName) UITests")
    }
    
    func renameAppDirectory() {
        enumerateCurrentPath(appendingPathComponent: oldName)
    }
    
    func renameProjectFile() {
        enumerateCurrentPath(appendingPathComponent: "\(oldName).xcodeproj")
    }
    
    func enumerateCurrentPath(appendingPathComponent pathComponent: String) {
        let currentPath = fileManager.currentDirectoryPath
        let path = currentPath.appending("/\(pathComponent)/")
        
        enumerateDirectory(atPath: path)
        renameItem(atPath: path)
    }
    
    func enumerateDirectory(atPath path: String) {
        print("\nDIRECTORY: \(path)")
        
        let enumerator = fileManager.enumerator(atPath: path)
        
        while let element = enumerator?.nextObject() as? String {
            if !shouldSkip(element) {
                let filePath = path.appending(element)
                updateContentsOfFile(atPath: filePath)
                renameItem(atPath: filePath)
            }
        }
    }
    
    func shouldSkip(_ element: String) -> Bool {
        guard !element.contains(".DS_Store") else { return true }
        
        let ext = URL(fileURLWithPath: element).pathExtension
        
        switch ext {
        case "plist", "xcassets", "appiconset", "json", "png", "lproj":
            return true
        default:
            return false
        }
    }
    
    func updateContentsOfFile(atPath path: String) {
        print("\nUPDATE ITEM: \(path)")
        
        do {
            let oldContent = try String(contentsOfFile: path, encoding: .utf8)
            if oldContent.contains(oldName) {
                print("UPDATE: \(path)")
                let newContent = oldContent.replacingOccurrences(of: oldName, with: newName)
                try newContent.write(toFile: path, atomically: true, encoding: .utf8)
            } else {
                print("SKIP: \(path)")
            }
            
        } catch {
            print("\(error)\n")
        }
    }
    
    func renameItem(atPath path: String) {
        print("\nRENAME ITEM: \(path)")
        
        do {
            let oldItemName = URL(fileURLWithPath: path).lastPathComponent
            if oldItemName.contains(oldName) {
                let newItemName = oldItemName.replacingOccurrences(of: oldName, with: newName)
                print("RENAME: \(oldItemName) -> \(newItemName)")
                
                let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
                let newPath = directoryURL.appendingPathComponent(newItemName).path
                
                try fileManager.moveItem(atPath: path, toPath: newPath)
            } else {
                print("SKIP: \(path)")
            }
        } catch {
            print(error)
        }
    }
    
}

let xpr = XcodeProjectRenamer(oldName: "Blueprint", newName: "Playground")
xpr.renameUnitTests()
xpr.renameUITests()
xpr.renameAppDirectory()
xpr.renameProjectFile()
