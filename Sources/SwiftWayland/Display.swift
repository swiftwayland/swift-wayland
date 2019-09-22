import Cwayland

public class WLDisplay {
    public let pointer: OpaquePointer

    public init?() {
        guard let wlDisplay = wl_display_create() else {
            return nil
        }

        self.pointer = wlDisplay
    }

    deinit {
        destroy()
    }

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func addSocketAutomatically() -> String? {
        guard let socket = wl_display_add_socket_auto(pointer) else {
            return nil
        }

        return String(cString: socket)
    }

    public func run() {
        wl_display_run(pointer)
    }

    public func destroy() {
        wl_display_destroy(pointer)
    }
}
