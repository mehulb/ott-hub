//
//  WindowButtonsPanel.swift
//  OTTHub
//
//  Created by Mehul Bhavani on 07/04/21.
//

import Cocoa

class WindowButtonsPanel: NSBox {
    override func mouseEntered(with event: NSEvent) {
        print("Mouse Entered")
    }
    override func mouseExited(with event: NSEvent) {
        print("Mouse Exited")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited], owner: self, userInfo: nil))
//    }
}

class WindowButton: NSButton {
    @IBInspectable var unselectedImage: NSImage?
    @IBInspectable var selectedImage: NSImage?
    
    override func mouseEntered(with event: NSEvent) {
        self.image = selectedImage
    }
    override func mouseExited(with event: NSEvent) {
        self.image = unselectedImage
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
}

class WindowDraggableButton: NSButton {
    
    // Allow the window to still be dragged from this button
    override func mouseDown(with mouseDownEvent: NSEvent) {
        let window = self.window!
        let startingPoint = mouseDownEvent.locationInWindow
        
        highlight(false)
//        highlight(true)
        
        // Track events until the mouse is up (in which we interpret as a click), or a drag starts (in which we pass off to the Window Server to perform the drag)
        var shouldCallSuper = false
        
        // trackEvents won't return until after the tracking all ends
        window.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout:NSEvent.foreverDuration, mode: .default) { event, stop in
            switch event!.type {
                case .leftMouseUp:
                    // Stop on a mouse up; post it back into the queue and call super so it can handle it
                    shouldCallSuper = true
                    NSApp.postEvent(event!, atStart: false)
                    stop.pointee = true
                    
                case .leftMouseDragged:
                    // track mouse drags, and if more than a few points are moved we start a drag
                    let currentPoint = event!.locationInWindow
                    if (abs(currentPoint.x - startingPoint.x) >= 5 || abs(currentPoint.y - startingPoint.y) >= 5) {
//                        self.highlight(false)
                        stop.pointee = true
                        window.performDrag(with: event!)
                    }
                    
                default:
                    break
            }
        }
        
        if (shouldCallSuper) {
            super.mouseDown(with: mouseDownEvent)
        }
    }
    
}
