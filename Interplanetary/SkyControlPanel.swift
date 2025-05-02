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

    var raPublisher: AnyPublisher<Double, Never> {
        raSubject.eraseToAnyPublisher()
    }

    var decPublisher: AnyPublisher<Double, Never> {
        decSubject.eraseToAnyPublisher()
    }

    var zoomPublisher: AnyPublisher<Double, Never> {
        zoomSubject.eraseToAnyPublisher()
    }
    
    private let titleBar = NSView()
    private let expandCollapseButton = NSButton(title: "Toggle", target: nil, action: nil)

    private let raSlider = NSSlider(value: 12.0, minValue: 0.0, maxValue: 24.0, target: nil, action: nil)
    private let decSlider = NSSlider(value: 0.0, minValue: -90.0, maxValue: 90.0, target: nil, action: nil)
    private let zoomSlider = NSSlider(value: 8.0, minValue: 2.0, maxValue: 24.0, target: nil, action: nil)

    private let raLabel = NSTextField(labelWithString: "RA: 12.00h")
    private let decLabel = NSTextField(labelWithString: "Dec: 0.00°")
    private let zoomLabel = NSTextField(labelWithString: "Zoom: 8.00×")

    private var initialLocation: NSPoint = .zero
    private var isResizing = false
    private var resizingCorner: Corner?

    private enum Corner {
        case bottomRight, bottomLeft, topLeft, topRight
    }

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
        [raSlider, decSlider, zoomSlider, raLabel, decLabel, zoomLabel].forEach {
            addSubview($0)
        }

        raSlider.target = self
        raSlider.action = #selector(raSliderChanged)

        decSlider.target = self
        decSlider.action = #selector(decSliderChanged)

        zoomSlider.target = self
        zoomSlider.action = #selector(zoomSliderChanged)
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
    
    var rightAscension: Double {
        raSlider.doubleValue
    }

    var declination: Double {
        decSlider.doubleValue
    }

    var zoom: Double {
        zoomSlider.doubleValue
    }

    var button: NSButton {
        expandCollapseButton
    }
    
}
