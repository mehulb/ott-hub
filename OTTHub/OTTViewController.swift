//
//  OTTViewController.swift
//  FloatTube
//
//  Created by Mehul Bhavani on 12/01/21.
//

import Cocoa
import WebKit
import LoggerAPI

class OTTViewController: NSViewController {
    private var service: [String: String]?
    
    @IBOutlet private var contentBox: NSBox?
    @IBOutlet private var activityView: NSProgressIndicator?
    
    private var webView: WKWebView?
    
    func loadService(_ service: [String: String]?) {
        if let service = service {
            self.service = service
            Log.error("load \(service["title"] ?? "-?-")")
            
            self.view.window?.title = service["title"] ?? "OTT Hub"
            
            contentBox?.wantsLayer = true
            contentBox?.layer?.masksToBounds = true
            
            let config = WKWebViewConfiguration()
            let webView = WKWebView(frame: (contentBox?.contentView?.bounds)!, configuration: config)
            webView.autoresizingMask = [.height, .width, .minXMargin, .minYMargin]
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(URLRequest(url: URL(string: service["url"]!)!))
            contentBox?.addSubview(webView, positioned: .above, relativeTo: nil)
            self.webView = webView
        }
    }
    func refreshPage() {
        webView?.reload()
    }
}

extension OTTViewController {
    @IBAction func reloadButton_Clicked(_ button: NSButton) {
        if NSApp.currentEvent?.clickCount == 2 {
            webView?.reloadFromOrigin()
        } else {
            webView?.reload()
        }
    }
    @IBAction func backwardButton_Clicked(_ button: NSButton) {
        webView?.goBack()
    }
    @IBAction func forwardButton_Clicked(_ button: NSButton) {
        webView?.goForward()
    }
}

// MARK: - WKUIDelegate
extension OTTViewController: WKUIDelegate {
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
                            Log.debug("Loaded url [\(url.absoluteString)] with app [\(app.localizedName ?? "--")]")
                        }
                        if let err = err {
                            Log.debug("but with error [\(err.localizedDescription)]")
                        }
                    }
                }
            }
        }
        return nil
    }
}

// MARK:- WKNavigationDelegate
extension OTTViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log.debug("didStartProvisionalNavigation")
        activityView?.startAnimation(self)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log.debug("didFinish")
        activityView?.stopAnimation(self)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Log.debug("\(error)")
        activityView?.stopAnimation(self)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Log.debug("\(error)")
        activityView?.stopAnimation(self)
    }
}

// Key events
extension OTTViewController {
    override func keyDown(with event: NSEvent) {
        Log.debug("\(event)")
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

