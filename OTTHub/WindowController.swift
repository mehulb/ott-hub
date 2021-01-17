//
//  WindowController.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.windowController = self
    }
}
