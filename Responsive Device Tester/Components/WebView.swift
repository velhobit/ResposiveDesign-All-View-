import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var url: URL
    var userAgent: String
    var onColorExtracted: (Color) -> Void
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let customUserAgent = userAgent
        webView.customUserAgent = customUserAgent
        
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.navigationDelegate = context.coordinator
        
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onColorExtracted: onColorExtracted)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var onColorExtracted: (Color) -> Void
        
        init(onColorExtracted: @escaping (Color) -> Void) {
            self.onColorExtracted = onColorExtracted
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.querySelector('meta[name=theme-color]')?.getAttribute('content')") { result, error in
                if let colorString = result as? String, let color = NSColor(hex: colorString) {
                    self.onColorExtracted(Color(color))
                } else {
                    // Fallback to system background color if needed
                    self.onColorExtracted(.clear)
                }
            }
        }
    }
}

extension NSColor {
    convenience init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
