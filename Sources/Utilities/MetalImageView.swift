import Foundation
import MetalKit


public final class MetalImageView: MTKView {
    
    /// The image to display
    public var image: CIImage? {
        didSet {
            renderImage()
        }
    }
    
    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    private lazy var commandQueue: MTLCommandQueue? = device?.makeCommandQueue()
    private lazy var ciContext: CIContext? = device.map { CIContext(mtlDevice: $0) }
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect,
            device: device ?? MTLCreateSystemDefaultDevice())
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        framebufferOnly = false
        backgroundColor = .clear
    }
        
    private func renderImage() {
        guard let image = image,
              let context = ciContext,
              let commandBuffer = commandQueue?.makeCommandBuffer(),
              let drawable = currentDrawable else { return }
        
        let bounds = CGRect(origin: CGPoint.zero, size: drawableSize)
        
        let originX = image.extent.origin.x
        let originY = image.extent.origin.y
        
        let scaleX = drawableSize.width / image.extent.width
        let scaleY = drawableSize.height / image.extent.height
        let scale = min(scaleX, scaleY)
        
        var scaledImage = image
            .transformed(by: CGAffineTransform(translationX: -originX, y: -originY))
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        #if targetEnvironment(simulator)
            scaledImage = scaledImage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
                .transformed(by: CGAffineTransform(translationX: 0, y: scaledImage.extent.height))
        #endif

        context.render(scaledImage,
            to: drawable.texture,
            commandBuffer: commandBuffer,
            bounds: bounds,
            colorSpace: colorSpace)
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
