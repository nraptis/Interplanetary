import Cocoa

class RootViewController: NSViewController {

    let containerView: NSView
    let rootViewModel: RootViewModel
    weak var timer: Timer?
    var isPushing = false
    private var viewController: NSViewController?

    var width: CGFloat
    var height: CGFloat
    
    init(rootViewModel: RootViewModel, width: CGFloat, height: CGFloat) {
        self.rootViewModel = rootViewModel
        self.width = width
        self.height = height
        
        let _containerView = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView = _containerView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func push(viewController: NSViewController,
              animated: Bool,
              reversed: Bool,
              completion: @escaping () -> Void) {

        guard !isPushing else {
            fatalError("Double Push, RVC...")
        }

        let previousViewController = self.viewController
        self.viewController = viewController

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        guard animated, let previousVC = previousViewController else {
            previousViewController?.view.removeFromSuperview()
            completion()
            return
        }

        isPushing = true
        let width = containerView.bounds.width
        let offset = reversed ? -width : width

        viewController.view.frame.origin.x = offset

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.44
            previousVC.view.animator().frame.origin.x = -offset
            viewController.view.animator().frame.origin.x = 0
        }, completionHandler: {
            previousVC.view.removeFromSuperview()
            self.isPushing = false
            completion()
        })
    }

}

