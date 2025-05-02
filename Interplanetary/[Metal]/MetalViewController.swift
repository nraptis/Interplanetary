import Cocoa

class MetalViewController: NSViewController {
    
    static weak var shared: MetalViewController?

    let delegate: GraphicsDelegate
    let graphics: Graphics
    let metalEngine: MetalEngine
    let metalPipeline: MetalPipeline
    let metalLayer: CAMetalLayer

    private var _isTimerRunning = false
    private var _isMetalEngineLoaded = false
    private var _isInitialized = false
    
    private var displayLink: CADisplayLink!

    nonisolated(unsafe) var isStereoscopicEnabled = false
    var isBloomEnabled = true

    var bloomPasses = 2
    let stereoSpreadBase = Float(4.0)
    let stereoSpreadMax = Float(12.0)

    let metalView: MetalView

    init(delegate: GraphicsDelegate, width: Float, height: Float) {
        let _metalView = MetalView(width: CGFloat(width), height: CGFloat(height))
        guard let _metalLayer = _metalView.layer as? CAMetalLayer else {
            fatalError("Unable to get CAMetalLayer from MetalView")
        }

        let _metalEngine = MetalEngine(metalLayer: _metalLayer, width: width, height: height)
        let _metalPipeline = MetalPipeline(metalEngine: _metalEngine)
        let _graphics = Graphics(width: width, height: height, scaleFactor: Float(NSScreen.main?.backingScaleFactor ?? 1.0))

        _metalEngine.graphics = _graphics
        _metalEngine.delegate = delegate

        _graphics.metalEngine = _metalEngine
        _graphics.metalPipeline = _metalPipeline
        _graphics.metalDevice = _metalEngine.metalDevice
        _graphics.metalView = _metalView

        delegate.graphics = _graphics

        self.delegate = delegate
        self.metalView = _metalView
        self.metalLayer = _metalLayer
        self.metalEngine = _metalEngine
        self.metalPipeline = _metalPipeline
        self.graphics = _graphics

        super.init(nibName: nil, bundle: nil)

        MetalViewController.shared = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = metalView
    }

    func load() {
        metalEngine.load()
        metalPipeline.load()
        graphics.buildPipelineStateTable(metalPipeline: metalPipeline)
        _isMetalEngineLoaded = true
        delegate.load()
        
        let _displayLink = metalView.displayLink(target: self, selector: #selector(tick(_:)))

        _displayLink.add(to: .main, forMode: .common)
        self.displayLink = _displayLink
    }

    func loadComplete() {
        delegate.loadComplete()
    }
    

    private var previousTimeStamp: CFTimeInterval?

    @objc func tick(_ sender: CADisplayLink) {
        drawloop()
    }
    
    @objc func drawloopWrapper() {
          
      }
    
    func drawloop() {
        
        print("drawloop became called")
        let timestamp = CACurrentMediaTime()
        var deltaTime: Float = 0.0
        if let previous = previousTimeStamp {
            deltaTime = Float(timestamp - previous)
        }
        previousTimeStamp = timestamp
        update(deltaTime: deltaTime)
        metalEngine.draw(isBloomEnabled: isBloomEnabled, bloomPasses: bloomPasses)
    }

    func update(deltaTime: Float) {
        if !_isInitialized {
            _isInitialized = true
            delegate.initialize()
        }
        delegate.update(deltaTime: deltaTime)
        print("Updated: \(deltaTime)")
    }
    
}
