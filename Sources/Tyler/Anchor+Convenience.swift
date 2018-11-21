
import Anchor

extension Anchor {

    public convenience init(_ tile: Tile) {
        self.init(.id(tile.id))
    }

    public func to(_ tile: Tile) -> Anchor {
        return to(tile.anchor)
    }
}
