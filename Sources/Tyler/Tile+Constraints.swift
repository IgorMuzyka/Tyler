
import Anchor
import Variable

#if os(iOS) || os(tvOS) || os(macOS)

extension Tile {

	internal func constraints(context: Context, pair: VariableResolutionPair) throws -> [NativeConstraint] {
        return try anchors.flatMap { try constraints(for: $0, in: context, pair: pair) }
	}

	internal func constraints(for anchor: Anchor, in context: Context, pair: VariableResolutionPair) throws -> [NativeConstraint] {
        return try anchor.constraints(context: anchor.context(in: context), pair: pair)
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
