import Foundation
import SwiftUI
import Combine


public struct MotionBlurModifier: ViewModifier {
    
    public let blurType: MotionBlurType
    public let blurOpacity: PassthroughSubject<Double,Never>
    
    public func body(content: Content) -> some View {
        content.overlay(
            StaticSnapshotRepresentable(blurType: blurType, opacitySubject: blurOpacity) {
                content      
            }
        )
    }
}


extension View {
    
    public func motionBlurOverlay(blurType: MotionBlurType,
                                  blurOpacity: PassthroughSubject<Double,Never>) -> some View {
        self.modifier(MotionBlurModifier(blurType: blurType, blurOpacity: blurOpacity))
    }
    
    public func motionBlurOverlay(scrollBroker: BlurredScrollViewBroker) -> some View {
        self.modifier(MotionBlurModifier(blurType: scrollBroker.options.blurType,
                                         blurOpacity: scrollBroker.blurRatioSubject))
    }
}
