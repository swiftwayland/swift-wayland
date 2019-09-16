import Cwayland

public struct WLList<Element>: Sequence {
    private let wlList: UnsafeMutablePointer<wl_list>
    private let linkKey: PartialKeyPath<Element>

    public var count: Int {
        get {
            return Int(wl_list_length(wlList))
        }
    }

    public var isEmpty: Bool {
        get {
            return wl_list_empty(wlList) == 1
        }
    }

    public init(
        _ pointer: UnsafeMutablePointer<wl_list>,
        linkKey: PartialKeyPath<Element>
    ) {
        self.wlList = pointer
        self.linkKey = linkKey
    }

    public func makeIterator() -> WLListIterator<Element> {
        return WLListIterator(wlList, linkKey)
    }
}

public struct WLListIterator<Element>: IteratorProtocol {
    private let wlList: UnsafeMutablePointer<wl_list>
    private var currentElement: UnsafeMutablePointer<wl_list>?

    private let linkKey: PartialKeyPath<Element>

    init(
        _ pointer: UnsafeMutablePointer<wl_list>,
        _ linkKey: PartialKeyPath<Element>
    ) {
        self.wlList = pointer
        self.currentElement = pointer

        self.linkKey = linkKey
    }

    public mutating func next() -> UnsafeMutablePointer<Element>? {
        guard let element = currentElement else {
            return nil
        }

        defer {
            currentElement = element.pointee.next
        }

        return wlContainer(of: element, key: linkKey)
    }
}
