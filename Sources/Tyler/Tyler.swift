
import Style
import Action
import Tag
import Variable
import Foundation

#if os(iOS) || os(tvOS) || os(macOS)

open class Tyler {

    public let factory: Factory
    public let stores: Stores
	private let log: (String) -> Void

    public init(
        factory: Factory,
        stylists: StylistsStore,
        stylesSerializers: StylesSerializersStore,
        actionHandlers: ActionHandlersStore = .default,
        actionSerializers: ActionsSerializersStore = .default,
        variableResolvers: VariableResolversStore = .default,
        log: @escaping (String) -> Void = { print($0) }
    ) {
        self.factory = factory
        self.stores = (stylists, stylesSerializers, actionHandlers, actionSerializers, variableResolvers)
        self.log = log
    }
}

public typealias Stores = (
    stylists: StylistsStore,
    stylesSerializers: StylesSerializersStore,
    actionHandlers: ActionHandlersStore,
    actionSerializers: ActionsSerializersStore,
    variableResolvers: VariableResolversStore
)

public extension Tyler {

    @discardableResult
    public func tile<Container: NativeView>(
        _ tile: Tile,
        in container: Container,
        pool: VariablePool,
        tags: [Tag] = [.wildcard]
    ) -> Context {
        if !container.subviews.isEmpty {
            container.subviews.forEach { $0.removeFromSuperview() }
        }

        return ({
                Context(
                    tile: Tile(Container.self, tiles: [tile]),
                    view: container,
                    contexts: [self.construct(tile, factory: self.factory)].compactMap { $0 }
            )}
            |> layout
            |> { ($0, self.stores, pool, tags) }
            |> style
            |> { ($0, self.stores, tags) }
            |> actionate
            |> { $0.manipulate(.activate, tags: tags) }
        )(())
	}

    @discardableResult
    public func layout(context: Context) -> Context {
        guard let contexts = context.contexts else { return context }

        context.constraints = contexts.flatMap { $0.produceConstraints() }

        contexts.forEach(disableAutoresizingMaskCosntraints)
        _ = contexts.map(layout)

        return context
    }

    @discardableResult
    public func actionate(context: Context, stores: Stores, tags: [Tag]) -> Context {
		if !context.tile.actionWraps.isEmpty {
			tags
				.match(context.tile.actionWraps)
				.compactMap { wrap in
					logErrorIfCatched { try wrap.unwrap(store: stores.actionSerializers) }
				}
				.forEach { action in
					logErrorIfCatched {
						try Actionator.actionate(view: context.view, with: action, store: stores.actionHandlers)
					}
				}
		}

		if !context.tile.actions.isEmpty {
			tags
				.match(context.tile.actions)
				.map { $0.value }
				.forEach { action in
					logErrorIfCatched {
						try Actionator.actionate(view: context.view, with: action, store: stores.actionHandlers)
					}
				}
		}

        context.contexts?.forEach { actionate(context: $0, stores: stores, tags: tags) }

        return context
    }

    @discardableResult
    public func style(context: Context, stores: Stores, pool: VariablePool, tags: [Tag]) -> Context {
		var styles = [Style]()

		if !context.tile.styleWraps.isEmpty {
			styles += tags
				.match(context.tile.styleWraps)
				.compactMap { wrap in
					logErrorIfCatched {
						try wrap.unwrap(store: stores.stylesSerializers)
					}
				}
		}

		if !context.tile.styles.isEmpty {
			styles += tags.match(context.tile.styles).map { $0.value }
		}

		if !styles.isEmpty {
			let stylists = styles.compactMap { $0.stylist(from: stores.stylists) }

			zip(styles, stylists).forEach { style, stylist in
				logErrorIfCatched {
					try stylist.style(anyStylable: context.view, style: style, tags: tags, pair: (pool, stores.variableResolvers))
				}
			}
		}

        context.contexts?.forEach { style(context: $0, stores: stores, pool: pool, tags: tags) }

        return context
	}

    internal func logErrorIfCatched<Output>(_ closure: () throws -> Output?) -> Output? {
        do {
            return try closure()
        } catch {
			self.log(error.localizedDescription)
            return nil
        }
    }

    private func disableAutoresizingMaskCosntraints(context: Context) {
        context.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func construct(_ tile: Tile, factory: Factory) -> Context? {
		guard let view = factory.produce(for: tile.targetClass) else {
			fatalError("Factory failed to produce view")
		}

        return Context(
            tile: tile,
            view: view,
            contexts: tile.tiles.compactMap { construct($0, factory: factory) }
        )
    }
}

precedencegroup LeftAssociativePrecedence {
    associativity: left
}

infix operator |> : LeftAssociativePrecedence

private func |> <T, U, V> (from: @escaping (T) -> U, to: @escaping (U) -> V) -> (T) -> V {
    return { to(from($0)) }
}

#else

open class Tyler {}

#endif

extension Tyler {

    internal static let decoder = JSONDecoder()
    internal static let encoder = JSONEncoder()
}
