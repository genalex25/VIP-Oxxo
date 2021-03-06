import Foundation
import UIKit
import SnapKit

public typealias PokemonDetailDelegate = (PokemonDetailActionsDelegate )

public protocol PokemonDetailActionsDelegate: class {
    func didTapBackButton()
    func didTapFavorite()
    func set(imageView: UIImageView?, with url: String)
}

public final class PokemonDetailView: UIView, PokemonDetailViewLogic {
    
    // MARK: - Public API
    public weak var delegate: PokemonDetailDelegate? 
    
    public lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        propertiesView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    public func set(viewModel: PokemonDetailViewModel) {
        self.title.text = viewModel.name
        self.firstType.text = viewModel.firstType
        self.firstType.backgroundColor = ColorTheme(rawValue: viewModel.firstType)?.color
        self.secType.text = viewModel.secType
        if let secType = viewModel.secType {
            self.secType.backgroundColor = ColorTheme(rawValue: secType)?.color
        }
        self.secType.isHidden = viewModel.secType == nil
        self.number.text = viewModel.order
        setFavColor(viewModel.favorited)
        delegate?.set(imageView: self.image, with: viewModel.image)
    }
    
    public func set(about viewModel: AboutPropertyViewModel) {
        self.propertiesView.set(about: viewModel)
    }
    
    public func set(favorite: Bool, success: Bool) {
        stopFavoriteLoading()
        guard success else { return }
        setFavColor(favorite)
    }
    
    private func setFavColor(_ favorited: Bool) {
        if favorited {
            favorite.setImage(filledHeart, for: .normal)
            return
        }
        favorite.setImage(emptyHeart, for: .normal)
    }
    
    override public func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            self.firstType.backgroundColor?.cgColor ?? UIColor.systemPurple.cgColor,
            self.secType.backgroundColor?.cgColor ?? UIColor.systemPink.cgColor
        ]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0.2, y: 1)
        gradient.cornerRadius = 10
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
    
    // MARK: - UI Components
    private lazy var back: UIButton = {
        let button = UIButton()
        button.setImage(backImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var favorite: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        let image = filledHeart
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var favoriteLoading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        view.startAnimating()
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Bulbasaur"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private lazy var number: UILabel = {
        let label = UILabel()
        label.text = "#001"
        label.textColor = .white
        return label
    }()
    
    private lazy var firstType: UILabel = {
        let label = RoundPaddingLabel()
        label.text = "Poison"
        label.backgroundColor = .blue
        label.textColor = .white
        return label
    }()
    
    private lazy var secType: UILabel = {
        let label = RoundPaddingLabel()
        label.text = "Flying"
        label.backgroundColor = .cyan
        label.textColor = .white
        return label
    }()
    
    private lazy var propertiesView: PropertiesView = {
        let view = PropertiesView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Actions
    private func setupTargets() {
        favorite.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        back.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc private func didTapFavorite() {
        delegate?.didTapFavorite()
        startFavoriteLoading()
    }
    
    @objc private func didTapBack() {
        delegate?.didTapBackButton()
    }
    
    private func startFavoriteLoading() {
        favorite.removeFromSuperview()
        addSubview(favoriteLoading)
        drawFavorite(favoriteLoading)
    }
    
    private func stopFavoriteLoading() {
        favoriteLoading.removeFromSuperview()
        addSubview(favorite)
        drawFavorite(favorite)
    }
    
    private var filledHeart: UIImage? {
        return UIImage(named: "heart", in: Bundle(for: type(of: self)), compatibleWith: .none)?.withRenderingMode(.alwaysTemplate)
    }
    
    private var emptyHeart: UIImage? {
        return UIImage(named: "heartEmpty", in: Bundle(for: type(of: self)), compatibleWith: .none)?.withRenderingMode(.alwaysTemplate)
    }

    private var backImage: UIImage? {
        return UIImage(named: "back", in: Bundle(for: type(of: self)), compatibleWith: .none)?.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - UI Implementation
extension PokemonDetailView: ViewCode {
    
    static let padding = 25
    
    func setupHierarchy() {
        addSubview(back)
        addSubview(favorite)
        addSubview(title)
        addSubview(number)
        addSubview(firstType)
        addSubview(secType)
        addSubview(propertiesView)
        addSubview(image)
    }
    
    func buildConstraints() {
        
        back.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).multipliedBy(2)
            } else {
                make.top.equalToSuperview()
            }
            make.left.equalToSuperview().inset(Self.padding)
            make.height.equalTo(20).priority(.required)
            make.width.equalTo(back.snp.height).multipliedBy(1.5)
        }
        
        drawFavorite(favorite)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(back.snp.bottom).offset(Self.padding)
            make.left.equalToSuperview().inset(Self.padding)
            make.height.equalTo(30).priority(.required)
        }
        
        number.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.right.equalToSuperview().inset(Self.padding)
        }
        
        firstType.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(Self.padding/2)
            make.left.equalTo(title)
        }
        
        secType.snp.makeConstraints { (make) in
            make.left.equalTo(firstType.snp.right).offset(Self.padding/2)
            make.centerY.equalTo(firstType)
        }
        
        propertiesView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.left.right.bottom.equalToSuperview()
        }
        
        image.snp.makeConstraints { (make) in
            make.top.equalTo(secType.snp.bottom).offset(Self.padding)
            make.centerX.equalTo(propertiesView)
            make.bottom.equalTo(propertiesView.snp.top).inset(Self.padding)
        }
    }
    
    private func drawFavorite(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.centerY.equalTo(back)
            make.height.equalTo(35)
            make.width.equalTo(view.snp.height)
            make.right.equalToSuperview().inset(Self.padding)
        }
    }
}
