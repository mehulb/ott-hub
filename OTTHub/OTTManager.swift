//
//  OTTManager.swift
//  OTTHub
//
//  Created by Mehul Bhavani on 08/04/21.
//

import Cocoa
import HeliumLogger
import LoggerAPI

class OTTManager {
    static let shared: OTTManager = {
        let manager = OTTManager()
        return manager
    }()
    private init() {}
    
    var controllers = [String: OTTWindowController]()
    var currentService: String {
        get {
            if let _ser = UserDefaults.standard.string(forKey: "currSer") {
                return _ser
            } else {
                return "youtube"
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "currSer")
        }
    }
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
        currentService = service
        if let windowController = controllers[service] {
            windowController.window?.makeKeyAndOrderFront(nil)
        } else {
            guard let mainStoryboardName = Bundle.main.infoDictionary?["NSMainStoryboardFile"] as? String else {
                fatalError("Seems like `NSMainStoryboardFile` is missed in `Info.plist` file.")
            }
            let mainStoryboard = NSStoryboard(name: NSStoryboard.Name(mainStoryboardName), bundle: Bundle.main)
            
            guard let windowController = mainStoryboard.instantiateController(withIdentifier: "WindowController") as? OTTWindowController else {
                fatalError("Initial controller is not `NSWindowController` in storyboard `\(mainStoryboard)`")
            }
            windowController.service = service
            windowController.window?.makeKeyAndOrderFront(nil)
            if let vc = windowController.contentViewController as? OTTViewController {
                vc.loadService(services[service]) 
            }
            controllers[service] = windowController
        }
    }
    func closeWindow(forService service: String) {
        controllers.removeValue(forKey: service)
    }
    func refreshWindow() {
        if let windowController = controllers[currentService] {
            if let viewController = windowController.contentViewController as? OTTViewController {
                viewController.refreshPage()
            }
        }
    }
}

extension OTTManager {
    func readServices() throws -> [OTTService]? {
        nil
    }
    func writeServices() throws {
        
    }
}

struct OTTService {
    var id: String?
    var title: String?
    var accentColorString: String?
    var imageName: String?
    var url: URL?
}
