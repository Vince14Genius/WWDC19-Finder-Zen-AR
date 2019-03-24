import Foundation

public struct CategoryBitMasks {
    public static let bullet       =         0b1
    public static let finder       =        0b10
    public static let platform     =       0b100
    public static let wall         =      0b1000
    
    //public static let powerUp      =     0b10000

    public static let bubbleBlue   =    0b100000
    public static let bubbleRed    =   0b1000000
    public static let bubbleYellow =  0b10000000
    public static let bubbleGreen  = 0b100000000
    
    public static let allBubbles =
        CategoryBitMasks.bubbleBlue | CategoryBitMasks.bubbleRed |
        CategoryBitMasks.bubbleYellow | CategoryBitMasks.bubbleGreen
    public static let all = Int.max
}

