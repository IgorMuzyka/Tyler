
import Tag
import Action
import Foundation

public class ActionWrap: Codable, Taggable {

    private let data: Data
    internal let actionType: String
    public var tags: [Tag] = []

	public init<GenericAction: Action>(action: GenericAction, tags: [Tag]) {
        actionType = String(reflecting: type(of: action))
		self.tags = tags
        data = try! Tyler.encoder.encode(action)
    }
}

#if os(iOS) || os(tvOS) || os(macOS)

extension ActionWrap {

    internal func unwrap(store: ActionsSerializersStore) throws -> Action? {
        return try store.access(key: actionType)?(data)
    }
}

#endif

extension Action {

	internal func wrap(tags: [Tag]) -> ActionWrap {
		return ActionWrap(action: self, tags: tags)
    }
}
