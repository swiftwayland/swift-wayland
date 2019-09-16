import Cwayland

public typealias WLListenerCallback<Value: RawPointerInitializable> = (
    _ data: Value
) -> Void

private typealias WLSignalCallback = (
    _ data: UnsafeMutableRawPointer?
) -> Void

func wlSignalAdd(
    _ signal: UnsafeMutablePointer<wl_signal>,
    _ listener: UnsafeMutablePointer<wl_listener>
) {
    wl_list_insert(signal.pointee.listener_list.prev, &listener.pointee.link)
}

func wlListenerContainerOf(_ listener: UnsafeMutablePointer<wl_listener>?)
    -> UnsafeMutablePointer<wl_listener_container>! {
    return wl_listener_container_of(listener)
}

private class WLListenerBox {
    let container: UnsafeMutablePointer<wl_listener_container>
    let callback: WLSignalCallback

    var notify: wl_notify_func_t {
        get {
            return container.pointee.listener.notify
        }
        set {
            container.pointee.listener.notify = newValue
        }
    }

    init(_ callback: @escaping WLSignalCallback) {
        self.container = UnsafeMutablePointer<wl_listener_container>
            .allocate(capacity: 1)
        self.callback = callback
    }
}

public class WLListener<Value: RawPointerInitializable> {
    let callback: WLListenerCallback<Value>

    init(_ callback: @escaping WLListenerCallback<Value>) {
        self.callback = callback
    }
}

public class WLSignal<Value: RawPointerInitializable> {
    let wlSignal: UnsafeMutablePointer<wl_signal>
    var listeners: [WLListener<Value>] = []

    // TODO: Release box on disposal.
    private var listenerBox: Unmanaged<WLListenerBox>?

    public init(_ pointer: UnsafeMutablePointer<wl_signal>) {
        self.wlSignal = pointer
    }

    public func listen(_ callback: @escaping WLListenerCallback<Value>) -> WLListener<Value> {
        if listeners.count == 0 {
            createListener()
        }

        let listener = WLListener(callback)
        listeners.append(listener)

        return listener
    }

    private func callback(_ data: UnsafeMutableRawPointer?) {
        for listener in listeners {
            listener.callback(Value.init(data!))
        }
    }

    private func createListener() {
        guard listenerBox == nil else {
            return
        }

        let listenerBox = Unmanaged<WLListenerBox>
            .passRetained(WLListenerBox(callback))

        listenerBox.takeUnretainedValue().container.pointee.instance =
            listenerBox.toOpaque()

        listenerBox.takeUnretainedValue().notify = { listener, data in
            let container = wlListenerContainerOf(listener)!
            let box = Unmanaged<WLListenerBox>.fromOpaque(
                container.pointee.instance
            ).takeUnretainedValue()

            box.callback(data)
        }

        wlSignalAdd(wlSignal,
            &listenerBox.takeUnretainedValue().container.pointee.listener
        )

        self.listenerBox = listenerBox
    }

    // TODO: Handle removing listener.
}
