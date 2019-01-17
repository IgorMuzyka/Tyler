
import TypePreservingCodingAdapter
import Tag
import Style

public final class StyleWrap: Tagged, Codable {

    public let tags: [Tag]
    public let style: Style

    private enum CodingKeys: CodingKey {

        case style
        case tags
    }

    public init(style: Style, tags: [Tag]) {
        self.style = style
        self.tags = tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tags = try container.decode([Tag].self, forKey: .tags)
        self.style = try container.decode(Wrap.self, forKey: .style).wrapped as! Style
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tags, forKey: .tags)
        try container.encode(Wrap(wrapped: style, strategy: .alias), forKey: .style)
    }
}
