import SwiftUI
import AppKit

import SwiftUI

class WindowManager: ObservableObject {
    var defaultDevice = DeviceProperties(
        image: "iphone_15_pro_max",
        width: 1290,
        height: 2796,
        radius: 60,
        padWidth: 0,
        padHeight: 0,
        ominBar: 45,
        userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1",
        topBarHeight: 70,
        browserHeaderHeight: 150,
        bezel: [40, 35, 40, 25],
        topBarPad: [40, 5],
        ratio: 3.0
    )
    
    @Published var selectedDevice: DeviceProperties? {
        didSet {
            updateWindow()
        }
    }
    
    private var window: NSWindow?
    
    init() {
        createWindow()
    }
    
    private func createWindow() {
        _ = Device(model: selectedDevice ?? defaultDevice)
            
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: .min, height: .min),
                styleMask: [.titled, .resizable, .hudWindow], // Remover a borda da janela
                backing: .buffered,
                defer: false
            )
            //window?.backgroundColor = NSColor.clear
            window?.title = "Device Viewer"
            window?.isOpaque = true
          //  window?.contentView = NSHostingView(rootView: contentView)
            window?.makeKeyAndOrderFront(nil)
    }

    private func updateWindow() {
        guard let window = window else { return }
        let contentView = Device(model: selectedDevice ?? defaultDevice)
        window.contentView = NSHostingView(rootView: contentView)
    }
}
