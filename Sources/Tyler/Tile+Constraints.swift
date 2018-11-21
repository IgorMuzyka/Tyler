
import Anchor

#if os(iOS) || os(tvOS) || os(macOS)

extension Tile {

	internal func constraints(context: Context) -> [NativeConstraint] {
		return anchors.flatMap { constraints(for: $0, in: context) }
	}

	internal func constraints(for anchor: Anchor, in context: Context) -> [NativeConstraint] {
		return anchor.constraints(context: anchor.context(in: context))
	}
}

extension Anchor {

	internal func context(in context: Context) -> Context! {
		switch subject {
		case .self: return context
		case .super: return context.super as? Context
		case .id(let id): return context.root.find(where: { $0.id == id }) as? Context
		}
	}
}

#endif
