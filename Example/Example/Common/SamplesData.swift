import Foundation


enum SamplesData {
    
    static let title = "Explore UI animation hitches and the render loop"
    
    static let shortText = "Metal API Validation Enabled"
    
    static let longText = "Overview. The scroll view displays its content within the scrollable content region. Creates a new instance that’s scrollable in the direction of the given axis and can show indicators while scrolling."
    
    static let shortInfo =
        """
        Explore how you can improve the performance of your app's user interface by identifying scrolling and animation hitches in your app. We'll take you through how hitches happen in the render loop, and explain how to measure hitch time ratio and fix the issues that most impact people using your app.
        """
    
    static let longInfo =
        """
        Multiple variadic parameters in functions
        SE-0284 introduced the ability to have functions, subscripts, and initializers use multiple variadic parameters as long as all parameters that follow a variadic parameter have labels. Before Swift 5.4, you could only have one variadic parameter in this situation.

        So, with this improvement in place we could write a function that accepts a variadic parameter storing the times goals were scored during a football match, plus a second variadic parameter scoring the names of players who scored

        Result builders
        Function builders unofficially arrived in Swift 5.1, but in the run up to Swift 5.4 they formally went through the Swift Evolution proposal process as SE-0289 in order to to be discussed and refined. As part of that process they were renamed to result builders to better reflect their actual purpose, and even acquired some new functionality.

        First up, the most important part: result builders allow us to create a new value step by step by passing in a sequence of our choosing. They power large parts of SwiftUI’s view creation system, so that when we have a VStack with a variety of views inside, Swift silently groups them together into an internal TupleView type so that they can be stored as a single child of the VStack – it turns a sequence of views into a single view.

        Result builders deserve their own detailed article, but I at least want to give you some small code examples so you can see them in action.

        Here is a function that returns a single string
        """
    
    static let details =
        """
        UIScrollView is the superclass of several UIKit classes including UITableView and UITextView.

        The central notion of a UIScrollView object (or, simply, a scroll view) is that it is a view whose origin is adjustable over the content view. It clips the content to its frame, which generally (but not necessarily) coincides with that of the application’s main window. A scroll view tracks the movements of fingers and adjusts the origin accordingly. The view that is showing its content “through” the scroll view draws that portion of itself based on the new origin, which is pinned to an offset in the content view. The scroll view itself does no drawing except for displaying vertical and horizontal scroll indicators. The scroll view must know the size of the content view so it knows when to stop scrolling; by default, it “bounces” back when scrolling exceeds the bounds of the content.

        The object that manages the drawing of content displayed in a scroll view should tile the content’s subviews so that no view exceeds the size of the screen. As users scroll in the scroll view, this object should add and remove subviews as necessary.

        Because a scroll view has no scroll bars, it must know whether a touch signals an intent to scroll versus an intent to track a subview in the content. To make this determination, it temporarily intercepts a touch-down event by starting a timer and, before the timer fires, seeing if the touching finger makes any movement. If the timer fires without a significant change in position, the scroll view sends tracking events to the touched subview of the content view. If the user then drags their finger far enough before the timer elapses, the scroll view cancels any tracking in the subview and performs the scrolling itself. Subclasses can override the touchesShouldBegin(_:with:in:), isPagingEnabled, and touchesShouldCancel(in:) methods (which are called by the scroll view) to affect how the scroll view handles scrolling gestures.

        A scroll view also handles zooming and panning of content. As the user makes a pinch-in or pinch-out gesture, the scroll view adjusts the offset and the scale of the content. When the gesture ends, the object managing the content view should update subviews of the content as necessary. (Note that the gesture can end and a finger could still be down.) While the gesture is in progress, the scroll view does not send any tracking calls to the subview.

        The UIScrollView class can have a delegate that must adopt the UIScrollViewDelegate protocol. For zooming and panning to work, the delegate must implement both viewForZooming(in:) and scrollViewDidEndZooming(_:with:atScale:); in addition, the maximum (maximumZoomScale) and minimum ( minimumZoomScale) zoom scale must be different.
        """
}
