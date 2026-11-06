import AppKit

// A non-interactive color surface behind the native, transparent menu bar.
// No menu items, mouse interception, wallpaper edits or Accessibility access.
final class TintPanel: NSPanel {
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect { frameRect }
}
final class MenuBarTint: NSObject, NSApplicationDelegate {
    private var panels: [NSPanel] = []
    func applicationDidFinishLaunching(_ notification: Notification) {
        rebuild()
        NotificationCenter.default.addObserver(self, selector: #selector(rebuild),
            name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    @objc func rebuild() {
        panels.forEach { $0.close() }
        panels = NSScreen.screens.map { screen in
            let height = max(NSStatusBar.system.thickness, screen.safeAreaInsets.top)
            let rect = NSRect(x: screen.frame.minX, y: screen.frame.maxY - height,
                width: screen.frame.width, height: height)
            let panel = TintPanel(contentRect: rect, styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered, defer: false)
            panel.backgroundColor = NSColor(srgbRed: 35.0/255, green: 42.0/255, blue: 46.0/255, alpha: 1)
            panel.isOpaque = true
            panel.hasShadow = false
            panel.ignoresMouseEvents = true
            panel.hidesOnDeactivate = false
            panel.isReleasedWhenClosed = false
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
            panel.orderFrontRegardless()
            return panel
        }
    }
}
let app = NSApplication.shared
let delegate = MenuBarTint()
app.setActivationPolicy(.accessory)
app.delegate = delegate
app.run()
