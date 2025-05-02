import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ App Did Finish Launching")
        
        NSApp.setActivationPolicy(.regular)
        
        let widthi = 1280
        let heighti = 900
        
        
        let _scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1.0
        
        Device.width = Float(widthi)
        Device.height = Float(heighti)
        Device.scale = Float(_scale)
        
        let rootViewModel = RootViewModel()  // Window handling will differ slightly
        ApplicationController.rootViewModel = rootViewModel
        
        let rootVC = RootViewController(rootViewModel: rootViewModel, width: CGFloat(widthi), height: CGFloat(heighti))
        ApplicationController.rootViewController = rootVC
        
        let contentSize = NSMakeRect(0, 0, CGFloat(widthi), CGFloat(heighti))
        let _window = NSWindow(contentRect: contentSize,
                               styleMask: [.titled, .closable, .resizable, .miniaturizable],
                               backing: .buffered,
                               defer: false)
        _window.title = "Interplanetary"
        _window.contentViewController = rootVC
        _window.center()
        _window.makeKeyAndOrderFront(nil)
        _window.isReleasedWhenClosed = false
        
        NSApp.activate(ignoringOtherApps: true)
        
        window = _window
        
        DispatchQueue.main.async {
            let interplanetaryDocument = InterplanetaryDocument()
            rootViewModel.pushToInterplanetaryScene(interplanetaryDocument: interplanetaryDocument,
                                                    animated: false,
                                                    reversed: false,
                                                    width: Float(widthi),
                                                    height: Float(heighti))
        }
        
    }
}
