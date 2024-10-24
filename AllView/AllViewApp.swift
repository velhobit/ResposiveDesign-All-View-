import SwiftUI

@main
struct AllViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(WindowManager())
        }
        .windowResizability(.contentSize)
        .windowResizability(WindowResizability.automatic)
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About All View") {
                    // Seu código
                }
            }
        }
    }
}

// Uma visual effect view para o background (opcional)
struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // Atualize a view quando necessário
    }
}
