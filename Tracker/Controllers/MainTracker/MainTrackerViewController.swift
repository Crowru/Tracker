//
//  MainTrackerViewController.swift
//  Tracker
//
//  Created by Руслан  on 24.08.2023.
//

import UIKit

final class MainTrackerViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellReuseIdentifier = "cell"
    
    private let errorImageView: UIImageView = {
        let image = UIImage(named: "errorImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSearch()
        setupViews()
        setupAllConstraints()
    }
    
    private func setupViews() {
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
    }
    
    private func setupAllConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 18),


        ])
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            let leftButton = UIBarButtonItem(image: UIImage(named: "addButton"), style: .plain, target: self, action: #selector(addNewCard))
            leftButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            
            let grayButton = UIButton(type: .system)
            grayButton.frame = CGRect(x: 0, y: 0, width: 77, height: 34)
            grayButton.setTitle("14.12.22", for: .normal)
            grayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            grayButton.setTitleColor(.ypBlack, for: .normal)  // Цвет текста
            grayButton.backgroundColor = .ypLightGray  // Цвет фона кнопки
            grayButton.layer.cornerRadius = 8  // Округление углов (если требуется)
            grayButton.addTarget(self, action: #selector(addNewCard), for: .touchUpInside)
            
            // Создание UIBarButtonItem с кастомной кнопкой
            let customBarButtonItem = UIBarButtonItem(customView: grayButton)
            
            // Установка кастомной кнопки как правой кнопки
            navBar.topItem?.setRightBarButton(customBarButtonItem, animated: true)
            
            
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
    }

    @objc
    private func addNewCard() {
        
    }

}

extension MainTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        //cell.contentView.backgroundColor = .red
        return cell
        
    }
    
}

extension MainTrackerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    private func setupSearch() {
        // Создание UISearchController
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Поиск"
        
        // Установка UISearchController в навигационную панель
        navigationItem.searchController = searchController
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlack,
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        
        
        // Оставить поиск видимым, даже при переходе на другой экран
        definesPresentationContext = true
    }
}
