
import Tag
import Style
import Identifier
import Anchor
import Action

open class Tile: Codable {

	internal let targetClass: String
	public let id: Identifier
	public var name: String?
	public internal(set) var anchors = [Anchor]()
	public internal(set) var tiles = [Tile]()
	public internal(set) var styles = [TagWrap<Style>]()
	public internal(set) var actions = [TagWrap<Action>]()

	internal var styleWraps = [StyleWrap]()
	internal var actionWraps = [ActionWrap]()

	public init(_ targetClass: String, name: String? = nil, tiles: [Tile] = []) {
		self.id = Identifier()
		self.targetClass = targetClass
		self.name = name
		self.tiles = tiles
	}

	public convenience init<TargetClass>(_ targetClass: TargetClass.Type, name: String? = nil, tiles: [Tile] = []) {
        self.init(String(reflecting: type(of: targetClass)), name: name, tiles: tiles)
	}

	public convenience init<TargetClass: RawRepresentable>(_ targetClass: TargetClass, name: String? = nil, tiles: [Tile] = [])
		where TargetClass.RawValue == String
	{
		self.init(targetClass.rawValue, name: name, tiles: tiles)
	}

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		guard
			let targetClass = try? values.decode(String.self, forKey: .targetClass),
			let id = try? values.decode(Identifier.self, forKey: .id),
			let name = try? values.decode(String?.self, forKey: .name),
			let anchors = try? values.decode([Anchor].self, forKey: .anchors),
			let tiles = try? values.decode([Tile].self, forKey: .tiles),
			let styleWraps = try? values.decode([StyleWrap].self, forKey: .styles),
			let actionWraps = try? values.decode([ActionWrap].self, forKey: .actions)
		else { throw TileCodingError.decoding("\(dump(values))") }

		self.targetClass = targetClass
		self.id = id
		self.name = name
		self.anchors = anchors
		self.tiles = tiles
		self.styleWraps = styleWraps
		self.actionWraps = actionWraps
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(targetClass, forKey: .targetClass)
		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(anchors, forKey: .anchors)
		try container.encode(tiles, forKey: .tiles)
		try container.encode(styleWraps + styles.map { $0.value.wrap(tags: $0.tags) }, forKey: .styles)
		try container.encode(actionWraps + actions.map { $0.value.wrap(tags: $0.tags) }, forKey: .actions)
	}
}

extension Tile {

	public enum TileCodingError: Error {

		case decoding(String)
	}

	private enum CodingKeys: String, CodingKey {

		case targetClass
		case id
		case name
		case anchors
		case tiles
		case styles
		case actions
	}
}

extension Tile {

	@discardableResult
	public func name(_ name: String) -> Self {
		self.name = name
		return self
	}

	public var anchor: Anchor {
		return Anchor(self)
	}

    @discardableResult
    public func anchor(_ anchor: Anchor) -> Self {
        anchors.append(anchor)
        return self
    }

	@discardableResult
	public func anchors(_ anchors: [Anchor]) -> Self {
		anchors.forEach { anchor($0) }
		return self
	}

    @discardableResult
	public func action(_ action: Action, tags: [Tag] = []) -> Self {
		actions.append(TagWrap(value: action, tags: tags))
        return self
    }
}

extension Tile: Stylable {

	@discardableResult
	public func style(style: Style, tags: [Tag] = []) -> Self {
		styles.append(TagWrap(value: style, tags: tags))
		return self
	}
}
