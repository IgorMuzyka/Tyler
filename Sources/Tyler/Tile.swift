
import Tag
import Style
import Identifier
import Anchor
import Action
import TypePreservingCodingAdapter

open class Tile: Codable {

	internal let targetClass: String
	public let id: Identifier
	public var name: String?
	public internal(set) var anchors = [Anchor]()
	public internal(set) var tiles = [Tile]()
	public internal(set) var styles = [StyleWrap]()
	public internal(set) var actions = [ActionWrap]()

	public init(_ targetClass: String, name: String? = nil, tiles: [Tile] = []) {
		self.id = Identifier()
		self.targetClass = targetClass
		self.name = name
		self.tiles = tiles
	}

	public convenience init<TargetClass>(_ targetClass: TargetClass.Type, name: String? = nil, tiles: [Tile] = []) {
        self.init(Signature(type: TargetClass.self).rawValue, name: name, tiles: tiles)
	}

	public convenience init<TargetClass: RawRepresentable>(_ targetClass: TargetClass, name: String? = nil, tiles: [Tile] = [])
		where TargetClass.RawValue == String
	{
		self.init(targetClass.rawValue, name: name, tiles: tiles)
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
        actions.append(ActionWrap(action: action, tags: tags))
        return self
    }
}

extension Tile: Stylable {

	@discardableResult
	public func style(style: Style, tags: [Tag] = []) -> Self {
        styles.append(StyleWrap(style: style, tags: tags))
		return self
	}
}
