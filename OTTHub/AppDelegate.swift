//
//  AppDelegate.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: WindowController? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        OTTManager.shared.showWindow(forService: "youtube")
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        ((windowController?.window?.makeKeyAndOrderFront(self)) != nil)
    }
    
    @IBAction func serviceMenuItem_Clicked(_ item: NSMenuItem) {
        if let id = item.identifier {
            OTTManager.shared.showWindow(forService: id.rawValue)
        }
    }
}

