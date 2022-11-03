//
//  StatusBar.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/1/22.
//

import AppKit


class StatusBar {
    static let shared = StatusBar()
    
    let item : NSStatusItem
    
    init() {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.behavior = .removalAllowed
        item.button?.action = #selector(clicked(sender:))
        item.button?.target = self
        setVisible(false)
    }
    
    func set(_ string: String, _ color: NSColor?) {
        if let color = color {
            //print("R: \(color.redComponent), B: \(color.blueComponent), G: \(color.greenComponent)")
            item.button?.attributedTitle = NSAttributedString(string: string, attributes: [.foregroundColor: color])
        } else {
            item.button?.title = string
        }
        setVisible(true)
    }
    
    func setVisible(_ visible: Bool) {
        item.isVisible = visible
    }
    
    @objc func clicked(sender: AnyObject) {
        ShortcutWindow.shared.hide()
        setVisible(false)
    }
}
