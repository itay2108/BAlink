//
//  ProductCollectionViewCell.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    var onReuse: () -> Void = {}
    
    var likeHandler: (() -> Void)?
    
    var isLiked: Bool = false {
        didSet {

            heartButton.setImage(isLiked ? K.images.filledHeart : K.images.heart, for: .normal)
        }
    }
    
    lazy var imageContainer: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.886, blue: 0.929, alpha: 0.85)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 6 * heightModifier
        return view
    }()
    
    private lazy var detailContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .top
        sv.spacing = 4
        return sv
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.minimumScaleFactor = 10
        label.contentMode = .top
        label.numberOfLines = 2
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.contentMode = .top
        label.textAlignment = .left
        label.numberOfLines = 4
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.contentMode = .top
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = isLiked ? K.images.filledHeart : K.images.heart
        config.baseForegroundColor = .red
        config.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.addTarget(self, action: #selector(handleHeartButtonTapped(_:)), for: .touchUpInside)
        
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        return button
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        return indicator
    }()
    
    func addSubviews() {
        addSubview(imageContainer)
        addSubview(detailContainer)
        
        detailContainer.addArrangedSubview(titleLabel)
        detailContainer.addArrangedSubview(descriptionLabel)
        detailContainer.addArrangedSubview(priceLabel)
        
        addSubview(heartButton)
        
        addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func setConstraintsToSubviews() {
        imageContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(imageContainer.snp.width)
        }
        
        detailContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(imageContainer.snp.bottom).offset(titleLabel.font.pointSize * 1.5)
        }
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(imageContainer.snp.center)
            make.height.equalTo(imageContainer.snp.height).multipliedBy(0.14)
            make.width.equalTo(imageContainer.snp.height).multipliedBy(0.14)
        }
        
        heartButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageContainer.snp.top).offset(4)
            make.right.equalTo(imageContainer).offset(-4)
            make.height.equalTo(imageContainer).multipliedBy(0.25)
            make.width.equalTo(heartButton.snp.width)
        }
        
    }
    
    @objc func handleHeartButtonTapped(_ button: UIButton) {
        isLiked = !isLiked
        likeHandler?()
    }
    
    func configure(with data: Product, image: UIImage?, isLiked: Bool) {
        imageContainer.image = image
        titleLabel.text = data.title.capitalized
        descriptionLabel.text = data.description.capitalized
        priceLabel.text = "$\(data.price)"
        self.isLiked = isLiked
        
        loadingIndicator.stopAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        imageContainer.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        priceLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraintsToSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}
