
import Tag
import Variable

#if os(iOS) || os(tvOS) || os(macOS)

extension Context {

	public enum ConstraintManipulation {

		case activate, deactivate, toggle
	}
}

extension Context {

	internal func produceConstraints(pair: VariableResolutionPair) throws -> [NativeConstraint] {
        return try tile.constraints(context: self, pair: pair)
	}

    @discardableResult
	public func manipulate(_ manipulation: ConstraintManipulation, tags: [Tag]) -> Context {
		let constraints = find(by: tags)

		switch manipulation {
		case .activate: NativeConstraint.activate(constraints)
		case .deactivate: NativeConstraint.deactivate(constraints)
		case .toggle: constraints.forEach { $0.isActive = !$0.isActive }
		}
        return self
	}

	internal func find(by tags: [Tag]) -> [NativeConstraint] {
		return tags.match(constraints) + (contexts?.flatMap { $0.find(by: tags) } ?? [])
	}
}

extension NativeConstraint: Tagged {

    public var tags: [Tag] {
        guard let identifier = identifier else { return [] }

		return identifier.components(separatedBy: Tag.separator).map { Tag.custom($0) }
    }
}

#endif
