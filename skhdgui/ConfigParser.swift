//
//  ConfigParser.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/2/22.
//

import Foundation

class ConfigParser {
    static func parse(_ mode: String, _ path: String) -> [[String]]? {        
        do {
            let string = try String(contentsOf: URL(fileURLWithPath: path, relativeTo: FileManager.default.homeDirectoryForCurrentUser))
                        
            // TODO: Add parsing of .load files
            
            let regex = try NSRegularExpression(pattern: "#\\s*(.*)\n\(mode)\\s*<\\s*(.*?)\\s*:")
            let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.count))
            
            return matches.map({
                return [
                    String(string[Range($0.range(at: 2), in: string)!]),
                    String(string[Range($0.range(at: 1), in: string)!])
                ]
            })
            
        } catch {
            print(error)
            return nil
        }
    }
    
    static func parseConfig(_ mode: String) -> [[String]]? {
        return parse(mode, ".config/skhd/skhdrc")
    }
}
