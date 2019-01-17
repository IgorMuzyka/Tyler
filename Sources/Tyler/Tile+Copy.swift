
import Anchor
import Tag
import Style
import Action
import Identifier

extension Tile {

    internal func copy() -> Tile {
        return replicate().swapIds().assemble()
    }

    private func replicate(super: Replica? = nil) -> Replica {
        let replica = Replica(
            originalId: id,
            tile: Tile.init(targetClass, name: name, tiles: []),
            anchors: anchors,
            styles: styles,
            actions: actions
        )
        let tilesReplicas = tiles.map { $0.replicate(super: replica) }
        replica.super = `super`
        replica.tilesReplicas = tilesReplicas

        return replica
    }
}

private final class Replica {

    let originalId: Identifier
    let tile: Tile
    var anchors: [Anchor]
    let styles: [StyleWrap]
    let actions: [ActionWrap]
    var tilesReplicas: [Replica]!
    weak var `super`: Replica?

    init(
        originalId: Identifier,
        tile: Tile,
        anchors: [Anchor],
        styles: [StyleWrap],
        actions: [ActionWrap]
    ) {
        self.originalId = originalId
        self.tile = tile
        self.anchors = anchors
        self.styles = styles
        self.actions = actions
    }
}

extension Anchor {

    fileprivate func swap(originalId: Identifier, with newId: Identifier) {
        if case let .id(id) = subject, id == originalId {
            subject = .id(newId)
        }

        if case let .anchor(anchor) = toValue {
            anchor.swap(originalId: originalId, with: newId)
        }
    }
}

extension Replica {

    @discardableResult
    fileprivate func swapIds() -> Replica {
        root.swap(originalId: originalId, with: tile.id)
        tilesReplicas.forEach { $0.swapIds() }
        return self
    }

    private func swap(originalId: Identifier, with newId: Identifier) {
        anchors.forEach { $0.swap(originalId: originalId, with: newId) }
        #warning("also provide a way to swap ids for actions")

        tilesReplicas.forEach { $0.swap(originalId: originalId, with: newId) }
    }

    fileprivate func assemble() -> Tile {
        tile.anchors = anchors
        tile.styles = styles
        tile.actions = actions
        tile.tiles = tilesReplicas.map { $0.assemble() }
        return tile
    }

    private var root: Replica {
        return `super`?.root ?? self
    }
}
