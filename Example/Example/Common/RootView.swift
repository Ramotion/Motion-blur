import Foundation
import SwiftUI


struct RootView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 70) {
                NavigationLink("Static (UIKit)", destination: VCRepresentable(vc: ScrollExample()))
                
                NavigationLink("Static (SwiftUI)", destination: SwiftUIDemo())
                
                NavigationLink("Dynamic (SwiftUI)", destination: MotionDistorsionDemo())
            }
            .navigationBarTitle("Motion blur", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

