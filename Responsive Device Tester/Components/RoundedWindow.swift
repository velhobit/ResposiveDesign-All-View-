//
//  RoundedWindow.swift
//  Responsive Device Tester
//
//  Created by Rodrigo Portillo on 25/07/24.
//


import Cocoa

class RoundedWindow: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Adiciona uma máscara de camada para arredondar os cantos da janela
        self.styleMask.insert(.fullSizeContentView)
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        
        let radius: CGFloat = 90.0
        let maskPath = NSBezierPath(roundedRect: self.contentView!.bounds, xRadius: radius, yRadius: radius)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        
        self.contentView?.wantsLayer = true
        self.contentView?.layer?.mask = shapeLayer
    }
}
