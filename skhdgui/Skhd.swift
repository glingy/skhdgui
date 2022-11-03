//
//  Skhd.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/2/22.
//

import Foundation

class Skhd {
    static let shared = Skhd()
    
    let path : String
    
    private init() {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = ProcessInfo.processInfo.environment["SHELL"]
        task.arguments = ["-lc", "which skhd"]
        task.standardOutput = pipe.fileHandleForWriting
        do {
            try task.run()
            task.waitUntilExit()
            try pipe.fileHandleForWriting.close()
        } catch {
            print("Error finding skhd.")
            exit(1)
        }
        
        if (task.terminationStatus != 0) {
            print("Failed to find skhd. Ensure skhd is in your path.")
            exit(1)
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        //guard let data = pipe.fileHandleForReading.readToEnd() else {
        //    print("Error reading path to skhd.")
        //    exit(1)
        //}
        
        path = String(data: data, encoding: .utf8)!
            .trimmingCharacters(in: .whitespacesAndNewlines)        
    }
    
    func type(_ key: String) {
        let task = Process()
        task.launchPath = path
        task.arguments = ["-k", key]
        do {
            try task.run()
        } catch {
            print("Error running skhd.")
            exit(1)
        }
        task.waitUntilExit()
    }

}
