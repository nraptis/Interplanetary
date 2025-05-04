//
//  SkyControlPanel.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Cocoa
import Combine

class SkyControlPanel: NSView {

    private let raSubject = PassthroughSubject<Double, Never>()
    private let decSubject = PassthroughSubject<Double, Never>()
    private let zoomSubject = PassthroughSubject<Double, Never>()
    private let swivelSubject = PassthroughSubject<Double, Never>()

    var raPublisher: AnyPublisher<Double, Never> {
        raSubject.eraseToAnyPublisher()
    }

    var decPublisher: AnyPublisher<Double, Never> {
        decSubject.eraseToAnyPublisher()
    }

    var zoomPublisher: AnyPublisher<Double, Never> {
        zoomSubject.eraseToAnyPublisher()
    }
    
    var swivelPublisher: AnyPublisher<Double, Never> {
            swivelSubject.eraseToAnyPublisher()
        }
    
    private let titleBar = NSView()
    private let expandCollapseButton = NSButton(title: "Toggle", target: nil, action: nil)

    private let raSlider = NSSlider(value: 12.0, minValue: 0.0, maxValue: 24.0, target: nil, action: nil)
    private let decSlider = NSSlider(value: 0.0, minValue: -90.0, maxValue: 90.0, target: nil, action: nil)
    private let zoomSlider = NSSlider(value: 8.0, minValue: 2.0, maxValue: 24.0, target: nil, action: nil)
    private let swivelSlider = NSSlider(value: 0.0, minValue: 0.0, maxValue: Double.pi * 2.0, target: nil, action: nil)


    private let raLabel = NSTextField(labelWithString: "RA: 12.00h")
    private let decLabel = NSTextField(labelWithString: "Dec: 0.00°")
    private let zoomLabel = NSTextField(labelWithString: "Zoom: 8.00×")
    private let swivelLabel = NSTextField(labelWithString: "Swivel: 8.00×")
    

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupUI()
    }

    private func setupUI() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.darkGray.cgColor
        layer?.cornerRadius = 10

        // === TITLE BAR ===
        titleBar.wantsLayer = true
        titleBar.layer?.backgroundColor = NSColor.gray.cgColor
        addSubview(titleBar)

        expandCollapseButton.bezelStyle = .rounded
        titleBar.addSubview(expandCollapseButton)

        // === SLIDERS + LABELS ===
        [raSlider, decSlider, zoomSlider, swivelSlider, raLabel, decLabel, zoomLabel, swivelLabel].forEach {
            addSubview($0)
        }

        raSlider.target = self
        raSlider.action = #selector(raSliderChanged)

        decSlider.target = self
        decSlider.action = #selector(decSliderChanged)

        zoomSlider.target = self
        zoomSlider.action = #selector(zoomSliderChanged)
        
        swivelSlider.target = self
        swivelSlider.action = #selector(swivelSliderChanged)
        
        if let interplanetaryViewModel = ApplicationController.shared.interplanetaryViewModel {
            raSlider.doubleValue = Double(interplanetaryViewModel.interplanetaryScene.rightAscension)
            decSlider.doubleValue = Double(interplanetaryViewModel.interplanetaryScene.declination)
            zoomSlider.doubleValue = Double(interplanetaryViewModel.interplanetaryScene.zoom)
            swivelSlider.doubleValue = Double(interplanetaryViewModel.interplanetaryScene.swivel)
            
            print("Fix'd raSlider.doubleValue => \(raSlider.doubleValue)")
            print("Fix'd raSlider.decSlider => \(decSlider.doubleValue)")
            print("Fix'd zoomSlider.doubleValue => \(zoomSlider.doubleValue)")
            print("Fix'd swivelSlider.doubleValue => \(swivelSlider.doubleValue)")
            
        }
        
    }

    override func layout() {
        super.layout()

        let padding: CGFloat = 10.0
        let labelWidth: CGFloat = 100.0
        let sliderHeight: CGFloat = 20.0
        let titleHeight: CGFloat = 30.0

        titleBar.frame = NSRect(x: 0, y: bounds.height - titleHeight, width: bounds.width, height: titleHeight)
        expandCollapseButton.frame = NSRect(x: bounds.width - 80, y: bounds.height - titleHeight + 2, width: 70, height: 24)

        raLabel.frame = NSRect(x: padding,
                               y: bounds.height - titleHeight - padding - sliderHeight,
                               width: labelWidth,
                               height: sliderHeight)

        raSlider.frame = NSRect(x: labelWidth + 2 * padding,
                                y: raLabel.frame.minY,
                                width: bounds.width - labelWidth - 3 * padding,
                                height: sliderHeight)

        decLabel.frame = NSRect(x: padding,
                                y: raLabel.frame.minY - padding - sliderHeight,
                                width: labelWidth,
                                height: sliderHeight)

        decSlider.frame = NSRect(x: labelWidth + 2 * padding,
                                 y: decLabel.frame.minY,
                                 width: bounds.width - labelWidth - 3 * padding,
                                 height: sliderHeight)

        zoomLabel.frame = NSRect(x: padding,
                                 y: decLabel.frame.minY - padding - sliderHeight,
                                 width: labelWidth,
                                 height: sliderHeight)

        zoomSlider.frame = NSRect(x: labelWidth + 2 * padding,
                                  y: zoomLabel.frame.minY,
                                  width: bounds.width - labelWidth - 3 * padding,
                                  height: sliderHeight)
        
        
        swivelLabel.frame = NSRect(x: padding,
                                 y: zoomLabel.frame.minY - padding - sliderHeight,
                                 width: labelWidth,
                                 height: sliderHeight)

        swivelSlider.frame = NSRect(x: labelWidth + 2 * padding,
                                  y: swivelLabel.frame.minY,
                                  width: bounds.width - labelWidth - 3 * padding,
                                  height: sliderHeight)

    }

    @objc private func raSliderChanged() {
        let value = raSlider.doubleValue
        raLabel.stringValue = String(format: "RA: %.2fh", value)
        raSubject.send(value)
    }

    @objc private func decSliderChanged() {
        let value = decSlider.doubleValue
        decLabel.stringValue = String(format: "Dec: %.2f°", value)
        decSubject.send(value)
    }

    @objc private func zoomSliderChanged() {
        let value = zoomSlider.doubleValue
        zoomLabel.stringValue = String(format: "Zoom: %.2fx", value)
        zoomSubject.send(value)
    }
    
    @objc private func swivelSliderChanged() {
        let value = swivelSlider.doubleValue
        swivelLabel.stringValue = String(format: "Swivel: %.2f°", value)
        swivelSubject.send(value)
    }
    
    var button: NSButton {
        expandCollapseButton
    }
    
}
