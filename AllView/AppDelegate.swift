//
//  AppDelegate.swift
//  AllView
//
//  Created by Rodrigo Portillo on 26/07/24.
//


import Cocoa
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            // Cria uma view com efeito de vidro e a adiciona ao conteúdo da janela
            let visualEffectView = NSVisualEffectView(frame: window.contentView!.bounds)
            visualEffectView.autoresizingMask = [.width, .height]
            visualEffectView.blendingMode = .behindWindow
            visualEffectView.material = .hudWindow // Ajuste o material conforme necessário
            visualEffectView.state = .active

            // Adiciona o visual effect view ao contentView
            window.contentView?.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
            
            // Adiciona uma view container para o conteúdo da janela
            let contentContainer = NSView(frame: window.contentView!.bounds)
            contentContainer.autoresizingMask = [.width, .height]
            window.contentView?.addSubview(contentContainer, positioned: .above, relativeTo: visualEffectView)
            
            // Configura a janela como não redimensionável
            window.styleMask.remove(.resizable)
            
            // Define a nova contentView
            window.contentView = contentContainer
            
            // Configura o ContentView para a nova contentView
            let hostingController = NSHostingController(rootView: ContentView())
            contentContainer.addSubview(hostingController.view)
            hostingController.view.frame = contentContainer.bounds
            hostingController.view.autoresizingMask = [.width, .height]
        }
    }
}
