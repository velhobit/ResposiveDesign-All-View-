import SwiftUI

@main
struct Responsive_Device_TesterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1179/3, height: 2556/3) // Define o tamanho inicial da ContentView
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = false
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            
            // Use a subclasse RoundedWindow em vez de NSWindow
            if let window = NSApplication.shared.windows.first as? RoundedWindow {
                // Define o tamanho da janela
                let contentViewSize = CGSize(width: 1179/3, height: 2556/3)
                window.setContentSize(contentViewSize)
                window.minSize = contentViewSize
                window.maxSize = contentViewSize
            }
        }
    }
}
