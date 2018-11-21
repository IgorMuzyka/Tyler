
import Tag

extension Tyler {

    public func copy(tile: Tile) -> Tile {
        if tile.nature == .dynamic {
            return tile.copy()
        } else {
            return dynamize(tile: tile).copy()
        }
    }

    public func dynamize(tile: Tile) -> Tile {
        tile.styles = tile.styleWraps.compactMap { wrap in
            if let style = logErrorIfCatched({ try wrap.unwrap(store: stores.stylesSerializers) }) {
                return TagWrap(value: style, tags: wrap.tags)
            } else {
                return nil
            }
        }
        tile.styleWraps = []

        tile.actions = tile.actionWraps.compactMap { wrap in
            if let action = logErrorIfCatched({ try wrap.unwrap(store: stores.actionSerializers) }) {
                return TagWrap(value: action, tags: wrap.tags)
            } else {
                return nil
            }
        }
        tile.actionWraps = []

        tile.tiles = tile.tiles.map(dynamize)

        return tile
    }
}
