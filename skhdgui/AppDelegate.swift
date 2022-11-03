//
//  main.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/1/22.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, MessagePortDelegate {
    func receive(_ request: Request) {
        switch (request) {
        case let .showStatusBar(label, color):
            let nsColor = color == nil ? nil : NSColor(red: CGFloat((color! >> 16) & 0xFF) / 255, green: CGFloat((color! >> 8) & 0xFF) / 255, blue: CGFloat(color! & 0xFF) / 255, alpha: 1)
            StatusBar.shared.set(label, nsColor)
            
        case let .showModeOptions(mode):
            guard let config = ConfigParser.parseConfig(mode) else {
                ShortcutWindow.shared.hide()
                return
            }
            
            ShortcutWindow.shared.setShortcuts(title: mode, config)
            ShortcutWindow.shared.show()
            
        case let .rawList(title, values):
            ShortcutWindow.shared.setShortcuts(title: title, values.enumerated().map({
                return [String($0.offset), $0.element]
            }))
            ShortcutWindow.shared.show()
            
        case .next: ShortcutWindow.shared.next()
        case .previous: ShortcutWindow.shared.previous()
        case .click: ShortcutWindow.shared.click()
        
        case .hideWindow: ShortcutWindow.shared.hide()
        case .hideStatusBar: StatusBar.shared.setVisible(false)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //StatusBar.shared.setVisible(true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
