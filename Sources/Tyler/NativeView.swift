
#if os(iOS) || os(tvOS)
import UIKit

public typealias NativeView = UIView
#elseif os(macOS)
import AppKit

public typealias NativeView = NSView
#endif
