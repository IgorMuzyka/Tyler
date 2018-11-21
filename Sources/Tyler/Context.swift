
import Anchor
import Identifier

#if os(iOS) || os(tvOS) || os(macOS)

public final class Context: ContextProtocol {

    public var id: Identifier { return tile.id }
	public let view: NativeView
	public let tile: Tile
	public private(set) var contexts: [Context]?
	internal var constraints = [NativeConstraint]()
	public weak var `super`: ContextProtocol? {
		didSet {
			guard let `super` = `super` else { return }
			view.removeFromSuperview()
			`super`.view.addSubview(view) // strange way to do this, but will do for now
		}
	}

	public init(tile: Tile, view: NativeView, contexts: [Context]?) {
		self.tile = tile
		self.view = view
		self.contexts = contexts
		self.contexts?.forEach { $0.super = self }
	}
}

extension Context {

	public func find(where predicate: (ContextProtocol) -> Bool) -> ContextProtocol? {
		guard let contexts = contexts else { return nil }

		if let context = contexts.first(where: predicate) {
			return context
		} else {
			for context in contexts {
				if let searched = context.find(where: predicate) {
					return searched
				}
			}
		}

		return nil
	}

	public func find(byName name: String) -> ContextProtocol? {
		return find(where: { ($0 as! Context).tile.name == name })
	}

	public var root: ContextProtocol {
		return `super`?.root ?? self
	}
}

#endif
