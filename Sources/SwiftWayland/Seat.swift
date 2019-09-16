import Cwayland

public struct WLSeatCapabilities: OptionSet {
    public let rawValue: UInt32

    static public let pointer = WLSeatCapabilities(
        rawValue: WL_SEAT_CAPABILITY_POINTER.rawValue)
    
    static public let keyboard = WLSeatCapabilities(
        rawValue: WL_SEAT_CAPABILITY_KEYBOARD.rawValue)
    
    static public let touch = WLSeatCapabilities(
        rawValue: WL_SEAT_CAPABILITY_TOUCH.rawValue)
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
