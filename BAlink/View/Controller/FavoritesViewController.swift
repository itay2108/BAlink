//
//  FavoritesViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import UIKit

class FavoritesViewController: ProductsViewController {
    
    override var isDisplayingFavorites: Bool {
        return true
    }
    
    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap on the heart of a product to make it appear here."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    convenience init() {
        self.init(with: FavoritesViewModel())
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.view.addSubview(emptyDataLabel)
        
        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalTo(productGallery)
            make.width.equalTo(productGallery).multipliedBy(0.7)
        }
    }
    
    //override numberOfItems to also display empty label when data source empty
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        emptyDataLabel.isHidden = viewModel.dataSource().count == 0 ? false : true
        
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
}



