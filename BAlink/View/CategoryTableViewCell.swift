//
//  CategoryTableViewCell.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    var category: String?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16 * heightModifier, weight: .medium)
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16 * heightModifier, weight: .regular)
        label.contentMode = .right
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .label.withAlphaComponent(0.66)
        label.minimumScaleFactor = 0.66
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    func addSubviews() {

        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
    }
    
    func setConstraintsToSubviews() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(36 * widthModifier)
            make.top.equalToSuperview().offset(16 * heightModifier)
            make.bottom.equalToSuperview().offset(-16 * heightModifier)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-36 * widthModifier)
            make.top.equalToSuperview().offset(16 * heightModifier)
            make.bottom.equalToSuperview().offset(-16 * heightModifier)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
    }
    
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubviews()
        setConstraintsToSubviews()
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with categoryName: String, productCount: Int?) {
        
        self.titleLabel.text = categoryName.capitalized
        
        if let count = productCount {
            detailLabel.text = "\(count)"
        }
        
        self.category = categoryName
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }

}
