//
//  ShortcutWindow.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/1/22.
//

import AppKit
//
//  KeyGrabberWindow.swift
//  cmdlet
//
//  Created by Gregory Ling on 9/24/22.
//

import AppKit
import SwiftUI

protocol ShortcutViewDelegate {
    func select(_ i: Int)
    func clicked(_ i: Int)
}

class ShortcutView: NSView {
    let delegate : ShortcutViewDelegate
    
    let SELECT_COLOR = NSColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    // 0.39 0.60 0.97
    
    let keys : NSTextField
    let label : NSTextField
    let i : Int
    var color: NSColor? = nil
    
    init(_ delegate : ShortcutViewDelegate, _ i: Int, _ strings: [String]) {
        self.delegate = delegate
        self.i = i
        self.keys = NSTextField(labelWithString: strings[0])
        self.label = NSTextField(labelWithString: strings[1])
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 50))
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        keys.translatesAutoresizingMaskIntoConstraints = false
        addSubview(keys)
                
        //removeConstraints(constraints)
        addConstraints([
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(greaterThanOrEqualTo: keys.rightAnchor, constant: 20),
            keys.centerYAnchor.constraint(equalTo: centerYAnchor),
            keys.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            heightAnchor.constraint(equalToConstant: 25),
        ])
                
        let area = NSTrackingArea(rect: visibleRect, options: [.mouseEnteredAndExited,.inVisibleRect,.activeAlways],owner: self)
        addTrackingArea(area)
        
        //isEmphasized = true
        //state = .active
        //state = .inactive
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .pointingHand)
    }
    
    override func mouseEntered(with event: NSEvent) {
        delegate.select(i)
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate.clicked(i)
    }
    
    override var mouseDownCanMoveWindow: Bool {
        get {
            return false
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // #1d161d
        if let color = color {
            color.setFill()
            dirtyRect.fill()
        }
    }
    
    func setSelected(_ selected: Bool) {
        if (selected) {
            color = NSColor.unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.7)
        } else {
            color = nil
        }
        setNeedsDisplay(bounds)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }
}


class TitleView: NSView {
    let label : NSTextField
    
    init(_ str: String) {
        label = NSTextField(labelWithString: str)
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 50))
        
        
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
                
        addConstraints([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }
}

class ShortcutWindow: NSWindow, ShortcutViewDelegate {
    static let shared = ShortcutWindow()
    
    var views : [ShortcutView] = []

    var selected = 0
    
    func select(_ i: Int) {
        guard i != selected else { return }
        guard i >= 0 && i < views.count else { return }
        views[selected].setSelected(false)
        selected = i
        views[selected].setSelected(true)
    }
    
    func clicked(_ i: Int) {
        Skhd.shared.type(views[i].keys.stringValue)
    }
    
    func click() {
        clicked(selected)
    }
    
    func next() {
        select(selected + 1)
    }
    
    func previous() {
        select(selected - 1)
    }
    
    
    func setShortcuts(title: String, _ shortcuts: [[String]]) {
        let contentView = self.contentView!
        contentView.subviews = []
        
        let titleView = TitleView(title)
        contentView.addSubview(titleView)
        
        
        
        
        views = shortcuts.enumerated().map {
            return ShortcutView(self, $0, $1)
        }
        
        var width = CGFloat(200)
        
        for i in views.indices {
            if (width.isLess(than: views[i].fittingSize.width)) {
                width = views[i].fittingSize.width
            }
            
            contentView.addSubview(views[i])
            //contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([
                i == views.startIndex ? titleView.bottomAnchor.constraint(equalTo: views[i].topAnchor) : views[i - 1].bottomAnchor.constraint(equalTo: views[i].topAnchor),
                contentView.leftAnchor.constraint(equalTo: views[i].leftAnchor),
                contentView.rightAnchor.constraint(equalTo: views[i].rightAnchor),
            ])
        }
        
        contentView.addConstraints([
            contentView.bottomAnchor.constraint(equalTo: views.last!.bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: width),
            contentView.topAnchor.constraint(equalTo: titleView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: titleView.rightAnchor),
        ])
        selected = 0
        views[selected].setSelected(true)
    }
        
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 500, height: 1000), styleMask: [.titled, .borderless], backing: .buffered, defer: false)
        
        UserDefaults.standard.set(kCFBooleanTrue, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        self.collectionBehavior = .moveToActiveSpace
        self.titlebarAppearsTransparent = true
        
        //self.backgroundColor = self.backgroundColor.withAlphaComponent(0.7)
        
        level = .floating
        
        styleMask.insert(.fullSizeContentView)
        
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        contentView = view
        
        hide()
        
        //self.isOpaque = false
        //self.backgroundColor = backgroundColor.withAlphaComponent(0.9)
        
        //contentView = NSHostingView(rootView: ShortcutsView())
        
        //setShortcuts(title: "Example", [
        //    ["r", "Hello"],
        //    ["rctrl - r", "Hello 1"],
        //    ["\"cmd - n\"", "Hello 2"],
        //    ["rcmd - n", "Hello 3"],
        //    ["rctrl - r", "Hello 4"],
        //    ["rctrl - r", "Hello 5"]
        //])
        
        
        
        
        
        
        
        
        //contentView.layout()
        
        
        
        //let parent = NSView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
        //contentView.addSubview(parent)
        //contentView.addConstraints([
        //    parent.topAnchor.constraint(equalTo: contentView.topAnchor),
        //    parent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        //    parent.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        //    parent.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        //])
//
        //let field = NSTextField(labelWithString: "")
        //field.translatesAutoresizingMaskIntoConstraints = false
        //field.stringValue = "⇪"
        //field.isSelectable = false
        //parent.addSubview(field)
        //
        //parent.addConstraints([
        //    parent.centerXAnchor.constraint(equalTo: field.centerXAnchor),
        //    parent.centerYAnchor.constraint(equalTo: field.centerYAnchor)
        //])
    }
    
    func show() {
        self.setIsVisible(true)
        self.makeKeyAndOrderFront(self)
        contentView?.layout()
        guard let scr = screen else {
            return
        }
        let x = scr.frame.width - frame.width
        let y = scr.frame.height - frame.height
        self.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    func hide() {
        self.setIsVisible(false)
    }
    
    override var canBecomeKey: Bool {
        get {
            return true
        }
    }
    
    override var canBecomeMain: Bool {
        get {
            return true
        }
    }
}
