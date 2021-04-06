//
//  ViewController.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa
import WebKit

class HeaderBox: NSBox {
    override func mouseUp(with event: NSEvent) {
        if event.clickCount == 2 {
            if let window = self.window {
                window.zoom(nil)
            }
        }
    }
}

class ViewController: NSViewController, WKUIDelegate {
    
    @IBOutlet var headerBox: HeaderBox?
    @IBOutlet var contentBox: NSBox?
    @IBOutlet var highlightBox: NSBox?
    
    @IBOutlet var contentBoxTopConstraint: NSLayoutConstraint?
    
    var currentWebView: WKWebView?
    
    var source: [String: [String: String]] = [
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
    var data = [String: WKWebView?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView("youtube")
        
        NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification, object: nil, queue: .main) { _ in
            self.updateUI(hide: false)
        }
        NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: nil, queue: .main) { _ in
            self.updateUI(hide: true)
        }
//        updateUI(hide: false)
        
//        contentBoxTopConstraint?.constant = 0.0
    }
    func updateUI(hide: Bool) {
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.1
            
            self.view.window?.standardWindowButton(.closeButton)?.animator().isHidden = hide
            self.view.window?.standardWindowButton(.miniaturizeButton)?.animator().isHidden = hide
            self.view.window?.standardWindowButton(.zoomButton)?.animator().isHidden = hide
            
            headerBox?.animator().isHidden = hide
            
            contentBoxTopConstraint?.animator().constant = hide ? 0.0 : 29.0
        } completionHandler: {}
    }
    
    func loadWebView(_ name: String) {
        if let wv = currentWebView {
            print("remove \(wv.title ?? "")")
            wv.removeFromSuperview()
        }
        
        if let webview = data[name] {
            if let webview = webview {
                print("load \(name)")
                contentBox?.addSubview(webview, positioned: .above, relativeTo: nil)
                currentWebView = webview
                return
            }
        } else if let service = source[name] {
            print("create \(name)")
            let config = WKWebViewConfiguration()
            let webview = WKWebView(frame: (contentBox?.contentView?.bounds)!, configuration: config)
            webview.autoresizingMask = [.height, .width, .minXMargin, .minYMargin]
            webview.uiDelegate = self
            webview.load(URLRequest(url: URL(string: service["url"]!)!))
            contentBox?.addSubview(webview, positioned: .above, relativeTo: nil)
            data[name] = webview
            currentWebView = webview
            return
        }
        print("something is wrong")
    }
    
    @IBAction func serviceButton_Clicked(_ button: FlatButton) {
        if let id = button.identifier {
            loadWebView(id.rawValue)
            NotificationCenter.default.post(name: FTNotificationNameServiceTabChanged, object: id)
        }
    }
    @IBAction func navigationActionButton_Clicked(_ button: FlatButton) {
        if let wv = currentWebView {
            switch button.tag {
                case -1:
                    wv.goBack()
                case 1:
                    wv.goForward()
                default:
                    wv.reload()
            }
        }
    }
    @IBAction func floatButton_Clicked(_ button: FlatButton) {
        if self.view.window!.level == .normal {
            self.view.window!.level = .floating
            button.iconColor = .systemRed
        }
        else {
            self.view.window!.level = .normal
            button.iconColor = .textColor
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            let alert = NSAlert()
            alert.messageText = "Do you want to open the following link in a browser window?"
            alert.informativeText = "\(url.absoluteString)"
            alert.addButton(withTitle: "Yes")
            alert.addButton(withTitle: "No")
            alert.beginSheetModal(for: self.view.window!) { (response) in
                if response == .alertFirstButtonReturn {
                    NSWorkspace.shared.open([url], withApplicationAt: URL(fileURLWithPath: "/Applications/Google Chrome.app"), configuration: NSWorkspace.OpenConfiguration()) { (app, err) in
                        if let app = app {
                            print("Loaded url [\(url.absoluteString)] with app [\(app.localizedName ?? "--")]")
                        }
                        if let err = err {
                            print("but with error [\(err.localizedDescription)]")
                        }
                    }
                }
            }
        }
        
        return nil
    }
}
// Key events
extension ViewController {
    override func keyDown(with event: NSEvent) {
        print("\(event)")
        if let characters = event.characters, characters.count == 1 {
            if event.modifierFlags.contains(.command) {
                if event.keyCode == 15 {            // "r"
                    currentWebView?.reload()
                    return
                } else if event.keyCode == 123 {    // "←"
                    currentWebView?.goBack()
                    return
                } else if event.keyCode == 124 {    // "→"
                    currentWebView?.goForward()
                    return
                } else if event.keyCode == 36 {     // "↵"
                    currentWebView?.reloadFromOrigin()
                    return
                }
            }
        }
        super.keyDown(with: event)
    }
}

