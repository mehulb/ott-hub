//
//  OTTManager.swift
//  OTTHub
//
//  Created by Mehul Bhavani on 08/04/21.
//

import Cocoa

class OTTManager {
    static let shared: OTTManager = {
        let manager = OTTManager()
        return manager
    }()
    private init() {}
    
    var controllers = [String: WindowController]()
    var currentService: String?
    var services: [String: [String: String]] = [
        "youtube": [
            "title": "YouTube",
            "accentColor": "#FD191E",
            "image": "youtube.png",
            "url": "https://www.youtube.com"
        ],
        "netflix": [
            "title": "Netflix",
            "accentColor": "#E41923",
            "image": "netflix.png",
            "url": "https://www.netflix.com"
        ],
        "primevideo": [
            "title": "PrimeVideo",
            "accentColor": "#10AADE",
            "image": "primevideo.png",
            "url": "https://www.primevideo.com"
        ],
        "hotstar": [
            "title": "Hotstar",
            "accentColor": "#12285D",
            "image": "hotstar.png",
            "url": "https://www.hotstar.com"
        ]
    ]
    
    func showWindow(forService service: String) {
        if let windowController = controllers[service] {
            windowController.window?.makeKeyAndOrderFront(nil)
        } else {
            guard let mainStoryboardName = Bundle.main.infoDictionary?["NSMainStoryboardFile"] as? String else {
                fatalError("Seems like `NSMainStoryboardFile` is missed in `Info.plist` file.")
            }
            let mainStoryboard = NSStoryboard(name: NSStoryboard.Name(mainStoryboardName), bundle: Bundle.main)
            
            guard let wc = mainStoryboard.instantiateController(withIdentifier: "WindowController") as? WindowController else {
                fatalError("Initial controller is not `NSWindowController` in storyboard `\(mainStoryboard)`")
            }
            let windowController = wc
            windowController.window?.makeKeyAndOrderFront(nil)
            if let vc = windowController.contentViewController as? ViewController {
                vc.loadService(services[service]) 
            }
            controllers[service] = windowController
        }
    }
}

struct OTTService {
    var id: String?
    var title: String?
    var accentColor: NSColor?
    var image: NSImage?
    var url: URL?
}
