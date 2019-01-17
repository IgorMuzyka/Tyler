
import TypePreservingCodingAdapter
import Tag
import Action

public final class ActionWrap: Tagged, Codable {

    public let tags: [Tag]
    public let action: Action

    private enum CodingKeys: CodingKey {

        case action
        case tags
    }

    public init(action: Action, tags: [Tag]) {
        self.action = action
        self.tags = tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tags = try container.decode([Tag].self, forKey: .tags)
        self.action = try container.decode(Wrap.self, forKey: .action).wrapped as! Action
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tags, forKey: .tags)
        try container.encode(Wrap(wrapped: action, strategy: .alias), forKey: .action)
    }
}
