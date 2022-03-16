//
//  FavoritesViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import UIKit

class FavoritesViewController: ProductsViewController {
    
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
        viewModel.delegate = self
    }
    
    
    
    override func setupUI() {
        super.setupUI()
        
        self.view.addSubview(emptyDataLabel)
        
        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalTo(productGallery)
            make.width.equalTo(productGallery).multipliedBy(0.7)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewModel.favoriteProducts = RealmManager.shared.realmFavorites(getProductsOf: viewModel.username)
        
        productGallery.reloadData()
    }
    
    //override numberOfItems to also display empty label when data source empty
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        emptyDataLabel.isHidden = viewModel.dataSource().count == 0 ? false : true
        
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    //override product cell likeHandler to also reload data after modification (to remove unliked items from gallery)
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        guard let cell = originalCell as? ProductCollectionViewCell,
            viewModel.dataSource().count > indexPath.row else {
            return originalCell
        }
        
        let product = viewModel.dataSource()[indexPath.row]
        
        cell.likeHandler = { [weak self] in
            if !cell.isLiked {
                self?.viewModel.removeFromFavorites(product)
                collectionView.reloadData()
            } else {
                self?.viewModel.addToFavorites(product)
            }
        }
        
        return cell
    }
    
}


