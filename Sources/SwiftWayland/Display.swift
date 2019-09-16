import Cwayland

public class WLDisplay {
    let wlDisplay: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.wlDisplay = pointer
    }
}
