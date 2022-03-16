//
//  ViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    
    private lazy var viewModel = CategoryViewModel()

    private var categories: [String] = [] {
        didSet{
            categoryTableView.reloadData()
        }
    }
    
    //MARK: - UI Views
    
    private lazy var logoutButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped(_:)))
        return item
    }()
    
    private lazy var mainDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14 * heightModifier, weight: .regular)
        label.textColor = .label.withAlphaComponent(0.66)
        label.text = "Browse some of the latest products"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let table = UITableView()
        table.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        table.rowHeight = 84 * heightModifier
        table.backgroundColor = .clear
        table.contentMode = .center
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .label
        return indicator
    }()
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categoryTableView.delegate = self; categoryTableView.dataSource = self
        viewModel.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        categoryTableView.delegate = nil; categoryTableView.dataSource = nil
        viewModel.delegate = nil
    }
    
    //MARK: - UI Methods
    
    private func setUpUI() {
        view.backgroundColor = K.colors.backgroundColor
        
        navigationItem.title = viewModel.personalGreeting()
        navigationItem.rightBarButtonItem = logoutButton
        
        addSubviews()
        setConstraints()
        
        activityIndicator.startAnimating()
        viewModel.getProducts()
        
    }
    
    func addSubviews() {

        view.addSubview(mainDescription)
        view.addSubview(categoryTableView)
    }

    private func setConstraints() {
        
        mainDescription.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(mainDescription.snp.bottom).offset(32 * heightModifier)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Selectors
    
    @objc private func logoutButtonTapped(_ button: UIButton) {
        present(viewModel.logoutAlert(), animated: true)
    }

}

extension CategoryViewController: CategoryViewModelDelegate {
    func categoryViewModel(didGetProducts products: [Product]) {
        activityIndicator.stopAnimating()
        categories = Array(Set(products.map { $0.type })).sorted()
    }
    
    func categoryViewModel(didFailGettingProductsWith error: Error) {
        activityIndicator.stopAnimating()
        
        present(viewModel.errorAlert(with: error.localizedDescription), animated: true)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as! CategoryTableViewCell
        
        guard categories.count > indexPath.row else {
            cell.titleLabel.text = "Error"
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let category = Array(categories)[indexPath.row]
        let productCountInCategory = viewModel.allProducts?.filter { $0.type == category }.count
        cell.configure(with: category, productCount: productCountInCategory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCategory = categories[indexPath.row]
        
        guard let products = (viewModel.allProducts?.filter { $0.type == selectedCategory }) else {
            return
        }
        
        let destination = viewModel.productViewController(with: products, of: selectedCategory)
        
        navigationController?.pushViewController(destination, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
}

