import Foundation
import UIKit


final class PropertiesView: UIView, PropertiesViewBorder {

    // MARK: - Public API
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        setupSegmentedControl()
        initialTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(about viewModel: AboutPropertyViewModel) {
        self.about.set(viewModel: viewModel)
    }
    
    // MARK: - UI Components
    private let titles = ["About"]
    
    private lazy var sections: UISegmentedControl = { [weak self] in
        guard let `self` = self else { return UISegmentedControl() }
        let control = UISegmentedControl(items: self.titles)
        control.backgroundColor = .white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
        return control
        }()
        
    private lazy var about: AboutPropertyView = {
        let view = AboutPropertyView()
        return view
    }()
    
    private func initialTap() {
        self.sections.selectedSegmentIndex = 0
    }
    
   
    private func setupSegmentedControl() {
        sections.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
    
    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            removeAllViews()
            draw(view: about)
        default: break
        }
    }
    
    private func removeAllViews() {
        self.about.removeFromSuperview()
    }
}

// MARK: - UI Implementation
extension PropertiesView: ViewCode {
    
    private static let padding = 10
    
    func setupHierarchy() {
        addSubview(sections)
    }
    
    func buildConstraints() {
        sections.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(Self.padding)
            make.top.equalToSuperview().offset(Self.padding)
        }
        
        draw(view: about)
    }
    
    func draw(view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(sections.snp.bottom).offset(Self.padding)
            make.left.right.bottom.equalToSuperview().inset(10)
        }
    }
}
