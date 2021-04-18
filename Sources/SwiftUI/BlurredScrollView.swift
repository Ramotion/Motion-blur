import Foundation
import SwiftUI


public struct BlurredScrollView<Content>: View where Content: View {
    
    @StateObject private var broker: BlurredScrollViewBroker
    @Binding private var contentOffset: CGFloat
    
    private let axis: Axis.Set
    private let showIndicators: Bool
    private let content: (ScrollViewProxy, BlurredScrollViewBroker) -> Content
    
    public init(axis: Axis.Set = .vertical,
                showIndicators: Bool = true,
                contentOffset: Binding<CGFloat> = .constant(0),
                blurRatioCallback: ((Double) -> Void)? = nil,
                options: MotionBlurOptions = .default,
                @ViewBuilder content: @escaping (ScrollViewProxy, BlurredScrollViewBroker) -> Content) {
        
        self.axis = axis
        self.showIndicators = showIndicators
        self.content = content
        _contentOffset = contentOffset
        
        let broker = BlurredScrollViewBroker(options: options, onTick: blurRatioCallback)
        _broker = StateObject(wrappedValue: broker)
    }
    
    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollViewReader { scrollProxy in
                ScrollView(axis, showsIndicators: showIndicators) {
                    ZStack(alignment: axis == .vertical ? .top : .leading) {
                        GeometryReader { insideProxy in
                            let offset = calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: [offset])
                        }
                        content(scrollProxy, broker)
                    }
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let offset = value[0]
                    contentOffset = offset
                    broker.updateScrollOffset(offset)
                }
            }
        }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axis == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}


private struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
