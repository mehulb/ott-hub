//
//  OTTWindowController.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa
import LoggerAPI

class OTTWindowController: NSWindowController {
    var service: String?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.windowController = self
        
        self.window?.standardWindowButton(.closeButton)?.isHidden = true
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
    }
}

class OTTWindow: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
    }
}
extension OTTWindow: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        Log.debug("\(String(describing: (self.windowController as! OTTWindowController).service))" )
        
        if let wc = self.windowController as? OTTWindowController {
            if let service = wc.service {
                OTTManager.shared.currentService = service
            }
        }
    }
    func windowDidResignKey(_ notification: Notification) {
        Log.debug("\(String(describing: (self.windowController as! OTTWindowController).service))" )
    }
    func windowDidBecomeMain(_ notification: Notification) {
        Log.debug("\(String(describing: (self.windowController as! OTTWindowController).service))" )
    }
    func windowDidResignMain(_ notification: Notification) {
        Log.debug("\(String(describing: (self.windowController as! OTTWindowController).service))" )
    }
    func windowWillClose(_ notification: Notification) {
        Log.debug("\(String(describing: (self.windowController as! OTTWindowController).service))" )
    }
}

class OTTWindowHeaderView: NSBox {
    @IBOutlet var buttonsPanel: NSView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
}

extension OTTWindowHeaderView {
    override func mouseEntered(with event: NSEvent) {
        show()
    }
    override func mouseExited(with event: NSEvent) {
        hide()
    }
    override public func mouseDown(with event: NSEvent) {
        self.window?.performDrag(with: event)
    }
    override public func mouseUp(with event: NSEvent) {
        if event.clickCount == 2 {
            self.window?.performZoom(self)
        }
    }
}

extension OTTWindowHeaderView {
    private func show() {
        self.fillColor = NSColor.black.withAlphaComponent(0.75)
        
        self.window?.standardWindowButton(.closeButton)?.isHidden = false
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = false
        self.window?.standardWindowButton(.zoomButton)?.isHidden = false
        //        self.window?.invalidateShadow()
        
        self.window?.titleVisibility = .visible
        
        buttonsPanel?.isHidden = false
    }
    private func hide() {
        self.fillColor = NSColor.clear
        
        self.window?.standardWindowButton(.closeButton)?.isHidden = true
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
        //        self.window?.invalidateShadow()
        
        self.window?.titleVisibility = .hidden
        
        buttonsPanel?.isHidden = true
    }
}
