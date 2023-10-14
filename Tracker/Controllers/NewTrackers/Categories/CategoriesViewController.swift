//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Руслан  on 04.09.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.size.width,
                                                  height: 500),
                                    style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = ColoursTheme.blackDayWhiteDay
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableKeys.addCategoryButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColoursTheme.whiteDayBlackDay
        button.setTitleColor(ColoursTheme.blackDayWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        return button
    }()
    
    var viewModel: CategoriesViewModel?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.dataIndexesCategories()
        setupViews()
        updateTableView()
    }
    
    // MARK: Initialisation
    func initialize(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        viewModel?.$categories.bind(action: { [weak self] _ in
            self?.updateTableView()
        })
    }
    
    // MARK: Functions
    private func goToAddNewCategory(isEdit: Bool = false, text: String? = nil) {
        guard let addNewCategoryViewController = viewModel?.addNewCategory(isEdit: isEdit, text: text) else { return }
        let navigationController = UINavigationController(rootViewController: addNewCategoryViewController)
        navigationController.navigationBar.barTintColor = ColoursTheme.blackDayWhiteDay
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
    
    private func updateTableView() {
        guard let categories = viewModel?.categories.isEmpty else { return }
        if categories {
            let emptyView = EmptyView(frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: view.bounds.height), image: ImageAssets.trackerErrorImage,
                                      text: LocalizableKeys.trackerViewStubCategory)
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        tableView.reloadData()
    }
    
    // MARK: Selectors
    @objc
    private func addNewCategory() {
        goToAddNewCategory(isEdit: false)
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.categories.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = viewModel?.categories[indexPath.row].title
        cell.accessoryType = indexPath == viewModel?.editingIndexPath ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteCategories(indexPath: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editingIndexPath = viewModel?.editingIndexPath {
            let previousSelectedCell = tableView.cellForRow(at: editingIndexPath)
            previousSelectedCell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        viewModel?.editingIndexPath = indexPath
        
        guard let categories = viewModel?.categories else { return }
        viewModel?.addDetailCategory(categories[indexPath.row].title)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        viewModel?.editingIndexPath = indexPath
        let editAction = UIAction(title: LocalizableKeys.contextMenuCategoryEdit) { [weak self] _ in
            guard let self else { return }
            if let editText = viewModel?.changeCategoryText() {
                self.goToAddNewCategory(isEdit: true, text: editText)
            }
        }
        let deleteAction = UIAction(title: LocalizableKeys.contextMenuCategoryDelete, attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.deleteCategories(indexPath: indexPath)
        }
        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        return UIContextMenuConfiguration(actionProvider: { _ in
            menu
        })
    }
}

// MARK: - SetupViews
private extension CategoriesViewController {
    func setupViews() {
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.addSubviews(tableView, addCategoryButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
