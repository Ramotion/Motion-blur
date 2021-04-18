import Foundation
import SwiftUI
import MotionBlur


struct SwiftUIDemo: View {
    
    var body: some View {
        BlurredScrollView { proxy, broker in
            VStack(spacing: 30) {
                Text(SamplesData.title)
                    .font(Font.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.black)
                    .motionBlurOverlay(scrollBroker: broker)
                
                Text(SamplesData.details)
                    .font(Font.system(size: 14))
                    .foregroundColor(Color.gray)
                    .motionBlurOverlay(scrollBroker: broker)
                
                Rectangle().fill(Color.red)
                    .overlay(
                        Text(SamplesData.shortText)
                            .font(Font.system(size: 22, weight: .semibold))
                            .foregroundColor(Color.white)
                    )
                    .padding()
                    .frame(width: 300, height: 200)
                    .motionBlurOverlay(scrollBroker: broker)
                
                Text(SamplesData.details)
                    .font(Font.system(size: 14))
                    .foregroundColor(Color.gray)
                    .motionBlurOverlay(scrollBroker: broker)
            }
            .padding()
        }
    }
}
