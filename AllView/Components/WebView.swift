import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var url: URL
    var userAgent: String
    var onColorExtracted: (Color) -> Void
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var webView: WKWebView?
    @Binding var buttonOpacity: Double
    @Binding var urlString: String
    @Binding var domainUri: String
    
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = CustomWKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.customUserAgent = userAgent
            //webView.frame = NSRect(x: 0, y: 0, width: 10, height: 600)
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.navigationDelegate = context.coordinator
        webView.scrollDelegate = context.coordinator
        self.webView = webView
        print("WebView frame size on creation: \(webView.frame.size.width) x \(webView.frame.size.height)")
        return webView
    }

    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let safeURLString = ensureScheme(for: urlString)
        if let url = URL(string: safeURLString) {
            // Adiciona um atraso antes de carregar a nova URL
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if nsView.url != url {
                    nsView.stopLoading()
                    nsView.load(URLRequest(url: url))
                    print("Loading URL: \(url)")
                }
            }
        } else {
            print("Invalid URL: \(safeURLString)")
        }
    }


    
    private func ensureScheme(for urlString: String) -> String {
        if URL(string: urlString)?.scheme == nil {
            return "http://\(urlString)"
        }
        return urlString
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, buttonOpacity: $buttonOpacity, urlString: $urlString, domainUri: $domainUri, onColorExtracted: onColorExtracted)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, ScrollDelegate {
        var parent: WebView
        @Binding var buttonOpacity: Double
        @Binding var urlString: String
        @Binding var domainUri: String
        var onColorExtracted: (Color) -> Void
        
        init(_ parent: WebView, buttonOpacity: Binding<Double>, urlString: Binding<String>, domainUri: Binding<String>, onColorExtracted: @escaping (Color) -> Void) {
            self.parent = parent
            _buttonOpacity = buttonOpacity
            _urlString = urlString
            _domainUri = domainUri
            self.onColorExtracted = onColorExtracted
        }
        
        func scrollViewDidScroll(with event: NSEvent) {
            let currentOffset = event.scrollingDeltaY
            print("Scrolling event deltaY: \(currentOffset)")
            if currentOffset >= 0 {
                buttonOpacity = 1.0
            } else if currentOffset < 0 {
                buttonOpacity = 0.0
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                urlString = url.absoluteString
            }
            if let host = webView.url?.host {
                domainUri = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
            }
            
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { [weak self] html, error in
                if let error = error {
                    print("JavaScript error: \(error.localizedDescription)")
                    return
                }
                
                guard let html = html as? String, let self = self else { return }
                if let dominantColor = self.extractBackgroundColor(from: html) {
                    DispatchQueue.main.async {
                        self.onColorExtracted(dominantColor)
                    }
                }
                
             
            }
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
            
            // Log dimensions of the web view
            let frame = webView.frame
            print("WebView frame size: \(frame.size.width) x \(frame.size.height)")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load with error: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to load provisional navigation with error: \(error.localizedDescription)")
        }

        
        func extractBackgroundColor(from html: String) -> Color? {
            let pattern = "<meta name=\"theme-color\".*?content=\"\\s*(#\\w{6}|#\\w{3}|rgba?\\(\\d+,\\s*\\d+,\\s*\\d+(?:,\\s*\\d+(?:\\.\\d+)?)?\\)).*?\""
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            guard let match = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count)) else {
                return nil
            }
            
            let nsRange = match.range(at: 1)
            guard let range = Range(nsRange, in: html) else {
                return nil
            }
            
            let colorString = String(html[range])
            
            return Color(hex: colorString)
        }
    }
}

protocol ScrollDelegate: AnyObject {
    func scrollViewDidScroll(with event: NSEvent)
}

class CustomWKWebView: WKWebView {
    weak var scrollDelegate: ScrollDelegate?
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        scrollDelegate?.scrollViewDidScroll(with: event)
    }
}

extension Color {
    init?(hex: String) {
        let r, g, b, a: Double
        var hexColor = hex
        
        if hex.hasPrefix("#") {
            hexColor = String(hex.dropFirst())
        }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            switch hexColor.count {
            case 6:
                r = Double((hexNumber & 0xff0000) >> 16) / 255
                g = Double((hexNumber & 0x00ff00) >> 8) / 255
                b = Double(hexNumber & 0x0000ff) / 255
                self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
                return
            case 8:
                r = Double((hexNumber & 0xff000000) >> 24) / 255
                g = Double((hexNumber & 0x00ff0000) >> 16) / 255
                b = Double((hexNumber & 0x0000ff00) >> 8) / 255
                a = Double(hexNumber & 0x000000ff) / 255
                self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
                return
            default:
                return nil
            }
        }
        return nil
    }
}
