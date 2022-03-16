//
//  ProductsViewController.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    let viewModel: ProductsViewModel
    
    var isDisplayingFavorites: Bool {
        return false
    }
    
    //MARK: UI Views
    
    lazy var productGallery: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 32 * heightModifier
        layout.minimumInteritemSpacing = 16 * widthModifier
        layout.scrollDirection = .vertical
    
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productGallery.delegate = self; productGallery.dataSource = self
        viewModel.delegate = self

        //update viewmodel favorite list from db before displaying
        viewModel.favoriteProducts = RealmManager.shared.realmFavorites(getProductsOf: viewModel.username)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        productGallery.delegate = nil; productGallery.dataSource = nil
        viewModel.delegate = nil
    }
    
    //MARK: - UI Methods
    
    func setupUI() {
        view.backgroundColor = K.colors.backgroundColor
        navigationItem.title = viewModel.category.capitalized
        
        let backButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
        backButton.title = "Categories"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        
        addSubviews()
        setConstraints()
        
    }
    
    private func addSubviews() {
        view.addSubview(productGallery)
    }
    
    private func setConstraints() {
        productGallery.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    //MARK: - Inits & Deinits
    
    init(with viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource().count
    }
    
    //define cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 32) / 2
        
        let size = CGSize(width: width, height: width * 2 + 16)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        guard viewModel.dataSource().count > indexPath.row else {
            return cell
        }
        
        let product = viewModel.dataSource()[indexPath.row]
        let isInFavorites = viewModel.isMarkedAsFavorite(product)
        
        let token = viewModel.getCharacterImage(of: product.imageUrl) { result in
            do {
                let image = try result.get()
                
                cell.configure(with: product, image: image, isLiked: isInFavorites)
            } catch {
                print(error)
                cell.configure(with: product, image: nil, isLiked: false)
            }
        }
        
        cell.likeHandler = { [unowned self] in
            if !cell.isLiked {
                self.viewModel.removeFromFavorites(product)
            } else {
                self.viewModel.addToFavorites(product)
            }
        }
        
        //cancel running requests when cell is reused
        cell.onReuse = { [weak self] in
          if let token = token {
              self?.viewModel.cancelRequest(token)
          }
        }
        
        return cell
    }
}

extension ProductsViewController: ProductsViewModelDelegate {
    func productsViewModel(favoriteProductsDidUpdateTo products: [Product]) {
        if isDisplayingFavorites {
            productGallery.reloadData()
        }
    }
}
