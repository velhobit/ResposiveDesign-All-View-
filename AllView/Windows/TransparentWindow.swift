import Cocoa
import AppKit

class TransparentWindow: NSWindow {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Isso garante que o tracking area é configurado quando a janela estiver carregada
        configureTrackingArea()
    }

    private func configureTrackingArea() {
        guard let contentView = self.contentView else { return }
        
        // Remove qualquer área de rastreamento anterior
        contentView.trackingAreas.forEach { contentView.removeTrackingArea($0) }
        
        let trackingArea = NSTrackingArea(
            rect: contentView.bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: contentView,
            userInfo: nil
        )
        contentView.addTrackingArea(trackingArea)
    }
}


extension NSView {
    override open func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.window?.alphaValue = 1.0 // Torna a janela totalmente visível
        self.layer?.borderWidth = 2 // Mostra a borda ao passar o mouse
        self.layer?.borderColor = NSColor.black.cgColor // Cor da borda
    }

    override open func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.window?.alphaValue = 0.5 // Torna a janela parcialmente transparente
        self.layer?.borderWidth = 0 // Remove a borda ao sair o mouse
    }
}
