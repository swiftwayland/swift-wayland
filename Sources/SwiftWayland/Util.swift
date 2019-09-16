import Cwayland

func wlContainer<T>(
    of member: UnsafeMutableRawPointer,
    key: PartialKeyPath<T>
) -> UnsafeMutablePointer<T> {
    return member
        .advanced(by: -MemoryLayout<T>.offset(of: key)!)
        .assumingMemoryBound(to: T.self)
}
