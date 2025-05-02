import Cocoa

class InterplanetaryContainerViewController: NSViewController {
    
    let interplanetaryViewController: InterplanetaryViewController
    required init(interplanetaryViewModel: InterplanetaryViewModel,
                  interplanetaryScene: InterplanetaryScene,
                  interplanetaryDocument: InterplanetaryDocument,
                  width: Float,
                  height: Float) {
        
        self.interplanetaryViewController = InterplanetaryViewController(interplanetaryViewModel: interplanetaryViewModel,
                                                                         interplanetaryScene: interplanetaryScene,
                                                                         interplanetaryDocument: interplanetaryDocument,
                                                                         width: width,
                                                                         height: height)
        
        super.init(nibName: nil, bundle: nil)
        
        view.clipsToBounds = true
        
        interplanetaryViewController.interplanetaryContainerViewController = self
    }
    
    override func loadView() {
        let rootView = NSView()
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.wantsLayer = true // optional: for layer-backed view
        
        interplanetaryViewController.view.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(interplanetaryViewController.view)
        
        NSLayoutConstraint.activate([
            interplanetaryViewController.view.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            interplanetaryViewController.view.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            interplanetaryViewController.view.topAnchor.constraint(equalTo: rootView.topAnchor),
            interplanetaryViewController.view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        
        self.view = rootView // ✅ Important!
    }
    
    func awake(interplanetaryViewModel: InterplanetaryViewModel, interplanetaryScene: InterplanetaryScene) {
        interplanetaryViewController.load()
        interplanetaryViewController.loadComplete()
    }
    
    deinit {
        print("[--] InterplanetaryContainerViewController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
