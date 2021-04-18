import Foundation
import SwiftUI
import MotionBlur


final class MotionDistorsionDemoVM: ObservableObject {
    
    var opacity: Double = 0
    var scale: Double = 0
    
    func update(blurRatio: Double) {
        opacity = blurRatio
        scale = Math.lerp(from: 0, to: -0.1, progress: blurRatio)
        objectWillChange.send()
    }
}


struct MotionDistorsionDemo: View {
    
    @StateObject var viewModel = MotionDistorsionDemoVM()
    
    var body: some View {
        ZStack {
            DynamicSnapshotRepresentable(opacity: viewModel.opacity, scale: viewModel.scale) {
                BlurredScrollView(axis: .vertical,
                                  showIndicators: true,
                                  blurRatioCallback: { viewModel.update(blurRatio: $0) },
                                  options: .default) { proxy, broker in
                    
                    VStack(spacing: 80) {
                        Text(SamplesData.shortInfo)
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.black)
                        
                        Text(SamplesData.longInfo)
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.gray)
                        
                        Text(SamplesData.details)
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.black)
                    }
                }
            }
        }
    }
}
