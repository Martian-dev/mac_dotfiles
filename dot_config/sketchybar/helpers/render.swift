import AppKit
import Darwin

let args = CommandLine.arguments
func writePNG(_ image: NSImage, to path: String, pixels: Int) {
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else { exit(1) }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    image.draw(in: NSRect(x: 0, y: 0, width: pixels, height: pixels))
    NSGraphicsContext.restoreGraphicsState()
    guard let data = rep.representation(using: .png, properties: [:]) else { exit(1) }
    try! data.write(to: URL(fileURLWithPath: path), options: .atomic)
}
func canvas(_ size: CGFloat, _ draw: () -> Void) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus(); draw(); image.unlockFocus()
    return image
}
if args.count < 3 { exit(1) }
switch args[1] {
case "app":
    guard args.count == 4,
        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: args[2]) else { exit(1) }
    writePNG(NSWorkspace.shared.icon(forFile: url.path), to: args[3], pixels: 28)
case "symbol":
    guard args.count == 4,
        let symbol = NSImage(systemSymbolName: args[2], accessibilityDescription: nil) else { exit(1) }
    let image = canvas(28) {
        symbol.draw(in: NSRect(x: 2, y: 2, width: 24, height: 24))
        NSColor(calibratedWhite: 0.84, alpha: 1).setFill()
        NSRect(x: 0, y: 0, width: 28, height: 28).fill(using: .sourceAtop)
    }
    writePNG(image, to: args[3], pixels: 28)
case "battery":
    guard args.count == 4, let value = Double(args[2]) else { exit(1) }
    let image = canvas(60) {
        let track = NSBezierPath(ovalIn: NSRect(x: 5, y: 5, width: 50, height: 50))
        track.lineWidth = 6
        NSColor(calibratedWhite: 1, alpha: 0.08).setStroke(); track.stroke()
        let arc = NSBezierPath()
        arc.appendArc(withCenter: NSPoint(x: 30, y: 30), radius: 25,
            startAngle: 90, endAngle: 90 - 360 * min(100, max(0, value)) / 100, clockwise: true)
        arc.lineWidth = 6; arc.lineCapStyle = .round
        (value < 20 ? NSColor.systemPink : NSColor(calibratedWhite: 0.91, alpha: 1)).setStroke()
        arc.stroke()
        let text = String(Int(value)) as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: NSColor(calibratedWhite: 0.91, alpha: 1)]
        let size = text.size(withAttributes: attributes)
        text.draw(at: NSPoint(x: (60 - size.width) / 2, y: (60 - size.height) / 2), withAttributes: attributes)
    }
    writePNG(image, to: args[3], pixels: 60)
case "cpu":
    var info = host_cpu_load_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
    let result = withUnsafeMutablePointer(to: &info) { pointer in
        pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
        }
    }
    guard result == KERN_SUCCESS else { exit(1) }
    let total = UInt64(info.cpu_ticks.0) + UInt64(info.cpu_ticks.1) + UInt64(info.cpu_ticks.2) + UInt64(info.cpu_ticks.3)
    let idle = UInt64(info.cpu_ticks.2)
    let old = (try? String(contentsOfFile: args[2], encoding: .utf8))?.split(separator: " ").compactMap { UInt64($0) }
    var usage = Double(total - idle) / Double(max(total, 1))
    if let old = old, old.count == 2, total > old[0], idle >= old[1] {
        usage = 1 - Double(idle - old[1]) / Double(total - old[0])
    }
    try! "\(total) \(idle)".write(toFile: args[2], atomically: true, encoding: .utf8)
    print(String(format: "%.4f", min(1, max(0, usage))))
default: exit(1)
}
