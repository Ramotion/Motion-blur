import Foundation
import UIKit
import MotionBlur


final class ScrollExample: UIViewController {
    
    private let titleLabel = UILabel()
    private let infoLabel1 = UILabel()
    private let detailsLabel1 = UILabel()
    private let infoLabel2 = UILabel()
    private let detailsLabel2 = UILabel()
    private let scrollView = UIScrollView()
    private let contentContainer = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        contentContainer.axis = .vertical
        contentContainer.spacing = 50
        scrollView.addSubview(contentContainer)
        contentContainer.edgesToSuperview()
        
        let wc = contentContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        contentContainer.addConstraint(wc)
        
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = UIColor.red
        titleLabel.numberOfLines = 0
        titleLabel.text = "Scroll view example"
        contentContainer.addArrangedSubview(titleLabel)
        
        infoLabel1.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        infoLabel1.textColor = UIColor(red: 0.15, green: 0.75, blue: 0.15, alpha: 1)
        infoLabel1.numberOfLines = 0
        infoLabel1.text = SamplesData.longText
        contentContainer.addArrangedSubview(infoLabel1)
        
        detailsLabel1.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailsLabel1.textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        detailsLabel1.numberOfLines = 0
        detailsLabel1.text = SamplesData.details
        contentContainer.addArrangedSubview(detailsLabel1)
        
        infoLabel2.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        infoLabel2.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.45, alpha: 1)
        infoLabel2.numberOfLines = 0
        infoLabel2.text = SamplesData.longText
        contentContainer.addArrangedSubview(infoLabel2)
        
        detailsLabel2.font = UIFont.systemFont(ofSize: 18, weight: .light)
        detailsLabel2.textColor = UIColor(red: 0.5, green: 0.35, blue: 0.35, alpha: 1)
        detailsLabel2.numberOfLines = 0
        detailsLabel2.text = SamplesData.longInfo
        contentContainer.addArrangedSubview(detailsLabel2)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval.oneFrame) {
            self.scrollView.enableMotionBlur()
        }
    }
}
