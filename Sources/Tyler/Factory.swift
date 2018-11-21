
#if os(iOS) || os(tvOS) || os(macOS)

public final class Factory {

    private var methods = [String: () -> NativeView]()

    public init() {}

    public func add<GenericView: NativeView>(_ method: @escaping () -> GenericView) -> Factory {
        let key = String(reflecting: type(of: GenericView.self))
        methods[key] = method
        return self
    }

    public func produce(for key: String) -> NativeView? {
        return methods[key]?()
    }
}

#endif
