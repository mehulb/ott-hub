//
//  AppDelegate.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa
import HeliumLogger
import LoggerAPI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: OTTWindowController? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let logger = HeliumLogger(.entry)
        logger.colored = false
//        logger.details = true
//        logger.fullFilePath = false
        logger.dateFormat = nil
        logger.timeZone = nil
        logger.format = "[(%type)][(%file).(%func) #(%line)] (%msg)"
        
        Log.logger = logger
        
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
    @IBAction func refreshMenuItem_Clicked(_ item: NSMenuItem) {
        OTTManager.shared.refreshWindow()
    }
}

