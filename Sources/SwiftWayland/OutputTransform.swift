import Cwayland

public enum WLOutputTransform: UInt32 {
    case normal = 0
    case transform90 = 1
    case transform180 = 2
    case transform270 = 3
    case flipped = 4
    case flipped90 = 5
    case flipped180 = 6
    case flipped270 = 7

    public var nativeValue: wl_output_transform {
        get {
            return wl_output_transform(self.rawValue)
        }
    }
}
