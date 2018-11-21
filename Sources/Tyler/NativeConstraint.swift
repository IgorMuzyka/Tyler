
#if os(iOS) || os(tvOS)
import UIKit

public typealias NativeConstraint = NSLayoutConstraint
#elseif os(macOS)
import AppKit

public typealias NativeConstraint = NSLayoutConstraint
#endif
