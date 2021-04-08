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

class ViewController: NSViewController {
    private var service: [String: String]?
    
    @IBOutlet private var headerBox: NSButton?
    @IBOutlet private var contentBox: NSBox?
    
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.standardWindowButton(.closeButton)?.isHidden = true
        self.view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.view.window?.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    func loadService(_ service: [String: String]?) {
        if let service = service {
            self.service = service
            print("load \(service["title"] ?? "-?-")")
            
            self.view.window?.title = service["title"] ?? "OTT Hub"
            
            let config = WKWebViewConfiguration()
            let webView = WKWebView(frame: (contentBox?.contentView?.bounds)!, configuration: config)
            webView.autoresizingMask = [.height, .width, .minXMargin, .minYMargin]
            webView.uiDelegate = self
            webView.load(URLRequest(url: URL(string: service["url"]!)!))
            contentBox?.addSubview(webView, positioned: .above, relativeTo: nil)
        }
    }
    
    @IBAction func closeButton_Clicked(_ button: NSButton) {
        self.view.window?.performClose(nil)
    }
    @IBAction func minimizeButton_Clicked(_ button: NSButton) {
        self.view.window?.performMiniaturize(nil)
    }
    @IBAction func zoomButton_Clicked(_ button: NSButton) {
        self.view.window?.performZoom(nil)
    }
}

// MARK: - WKUIDelegate
extension ViewController: WKUIDelegate {
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
                    webView?.reload()
                    return
                } else if event.keyCode == 123 {    // "←"
                    webView?.goBack()
                    return
                } else if event.keyCode == 124 {    // "→"
                    webView?.goForward()
                    return
                } else if event.keyCode == 36 {     // "↵"
                    webView?.reloadFromOrigin()
                    return
                }
            }
        }
        super.keyDown(with: event)
    }
}

