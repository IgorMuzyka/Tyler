
import Style
import Tag
import Foundation

public class StyleWrap: Codable, Taggable {

    private let data: Data
    internal let styleType: String
    public var tags: [Tag] = []

	public init<GenericStyle: Style>(style: GenericStyle, tags: [Tag]) {
        styleType = String(reflecting: type(of: style))
        data = try! Tyler.encoder.encode(style)
    }
}

#if os(iOS) || os(tvOS) || os(macOS)

extension StyleWrap {

	internal func unwrap(store: StylesSerializersStore) throws -> Style? {
		return try store.access(key: styleType)?(data)
	}
}

#endif

extension Style {

	internal func wrap(tags: [Tag]) -> StyleWrap {
		return StyleWrap(style: self, tags: tags)
    }
}
