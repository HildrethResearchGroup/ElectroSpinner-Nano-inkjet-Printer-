//
//  PrintButton.swift
//  ElectroSpinner
//
//  Created by Owen Hildreth on 2/23/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Cocoa

//@IBDesignable
class PrintButton: NSButton {
    var delegate: PrintButtonDelegate? = nil
    
    let color_disabled = NSColor.lightGray
    let color_readyForPrinting = NSColor.green
    let color_printing = NSColor.yellow
    //let color_finishedPrinting = NSColor.orange
    let color_error = NSColor.red
    
    var status = PrintStatus.readyForPrinting {
        didSet {
            self.needsDisplay = true
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.delegate?.printButtonDown(sender: self)
        if let delegateStatus = self.delegate?.printButtonStatus(sender: self) {
            self.status = delegateStatus
        } else {self.status = .disabled }
        
    }
    
    override func mouseUp(with event: NSEvent) {
        self.delegate?.printButtonUp(sender: self)
        if let delegateStatus = self.delegate?.printButtonStatus(sender: self) {
            self.status = delegateStatus
        } else {self.status = .readyForPrinting }
    }

}


// MARK: - Drawing
extension PrintButton {
    
    private func getFillColor() -> NSColor {
        switch self.status {
        case .disabled, .notConnected: return color_disabled
        case .readyForPrinting: return color_readyForPrinting
        case .printing: return color_printing
        case .error: return color_error
        }
    }
    
    
    /// Make the stroke color slightly darker than the fill color
    private func getStrokeColor() -> NSColor {
        let fillColor = self.getFillColor()
        let percentage:CGFloat = 30/100
        var red = fillColor.redComponent
        var green = fillColor.greenComponent
        var blue = fillColor.blueComponent
        let alpha = fillColor.alphaComponent

        red = min(red - percentage, 1.0)
        green = min(green - percentage, 1.0)
        blue = min(blue - percentage, 1.0)
        
        let strokeColor = NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        
        return strokeColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Fill the background with white
        //NSColor.white.setFill()
        //dirtyRect.fill()
        
        let sframe = self.bounds
        
        let ovalRect = NSMakeRect(sframe.minX + 2, sframe.minY + 2, sframe.width - 4, sframe.height - 4)
        
        let ovalPath = NSBezierPath(ovalIn: ovalRect)
        let fillColor = self.getFillColor()
        let strokeColor = self.getStrokeColor()
        fillColor.setFill()
        ovalPath.fill()
        strokeColor.setStroke()
        ovalPath.lineWidth = 1.5
        ovalPath.stroke()
    }
    
}


// MARK: - Delegate

protocol PrintButtonDelegate: AnyObject {
    func printButtonDown(sender: PrintButton)
    func printButtonUp(sender: PrintButton)
    
    func printButtonStatus(sender: PrintButton) -> PrintStatus
    
}



