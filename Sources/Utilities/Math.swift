import Foundation


public enum Math {
    public static func lerp<T: FloatingPoint>(from: T, to: T, progress: T) -> T {
        return from + progress * (to - from)
    }
}


extension TimeInterval {
    public static var oneFrame: TimeInterval {
        return 1 / 60.0
    }
}
