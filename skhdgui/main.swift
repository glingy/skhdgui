//
//  main.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/1/22.
//

import AppKit

import ArgumentParser

struct Skhdgui: ParsableCommand {
    //static let configuration = CommandConfiguration(
    //    abstract: "Displays a GUI for use with skhd.")

    @Option(name: .shortAndLong, help: "Show the status bar with label")
    var status: String?
    
    @Option(name: .shortAndLong, help: "Color for the status item (#817A2B)")
    var color: String?
    
    @Option(name: .shortAndLong, help: "Show the window for mode")
    var window: String?
    
    @Flag(name: .shortAndLong, help: "Select the next item")
    var next = false
    
    @Flag(name: .shortAndLong, help: "Select the previous item")
    var previous = false
    
    @Flag(name: [.customShort("C"), .long], help: "Click the selected item")
    var click = false
    
    @Flag(name: [.customShort("W"), .long], help: "Hide the window if visible")
    var hideWindow = false
    
    @Flag(name: [.customShort("S"), .long], help: "Hide the status item if visible")
    var hideStatus = false
    
    @Flag(name: .shortAndLong, help: "Run as gui daemon")
    var daemon = false
    
    func validate() throws {
        //guard highValue >= 1 else {
        //    throw ValidationError("'<high-value>' must be at least 1.")
        //}
    }
    
    func run() {
        if (daemon) {
            let delegate = AppDelegate()
            MessagePortServer.shared.delegate = delegate
            NSApplication.shared.delegate = delegate
            NSApplication.shared.run()
            
            return;
        }
        
        
        var requests: [Request] = []
        if (status != nil) {
            var c: Int? = nil
            if (color != nil) {
                if (color!.starts(with: "#")) {
                    c = Int(color!.dropFirst(1), radix: 16)
                } else {
                    c = Int(color!, radix: 16)
                }
            }
            requests.append(.showStatusBar(label: status!, color: c))
        }
        
        if (window != nil) {
            requests.append(.showModeOptions(mode: window!))
        }
        
        if (next) {
            requests.append(.next)
        }
        
        if (previous) {
            requests.append(.previous)
        }
        
        if (click) {
            requests.append(.click)
        }
        
        if (hideWindow) {
            requests.append(.hideWindow)
        }
        
        if (hideStatus) {
            requests.append(.hideStatusBar)
        }
        
        if (requests.count > 0) {
            MessagePortClient.shared.send(requests)
        } else {
            print(Skhdgui.helpMessage())
        }
    }
}


Skhdgui.main()

