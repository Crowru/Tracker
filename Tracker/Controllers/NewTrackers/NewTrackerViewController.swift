//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Руслан  on 01.09.2023.
//

import UIKit

//MARK: - HabitDelegate
protocol HabitDelegate: AnyObject {
    func addDetailCategory(_ text: String)
    func addDetailDays(_ days: [String])
}

//MARK: - NewTrackerViewController
final class NewTrackerViewController: UIViewController {
    
    private let namesButton: [String] = ["Категория", "Расписание"]
    
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = UIColor.colorSelection
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .yp_Red
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var chooseIrregularEvent: Bool = false
    
    var onTrackerCreated: ((_ tracker: Tracker, _ titleCategory: String?) -> Void)?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        textField.placeholder = "Введите название трекера"
        textField.leftViewMode = .always
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200),
                                    style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SubtitledTableViewCell.identifier)
        tableView.register(SubtitledTableViewCell.self, forCellReuseIdentifier: SubtitledTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(ColorsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorsCollectionViewCell.identifier)
        collectionView.register(HeaderViewCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.yp_Red.cgColor
        button.setTitleColor(.yp_Red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(exitView), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .yp_Gray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createNewTracker), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(limitLabel)
        return stackView
    }()
    
    private var collectionViewHeightContraint: NSLayoutConstraint!
    private var detailTextCategory: String?
    private var detailTextDays: [String]?
    private var isSelectedEmoji: IndexPath?
    private var isSelectedColor: IndexPath?
    private var isEnabledDictionary = ["text": false, "category": false, "timatable": false, "emoji": false, "colour": false]
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateCollectionViewHeight()
    }
    
    private func createButtonIsEnabled() {
        guard isEnabledDictionary["text"] == true &&
                isEnabledDictionary["category"] == true &&
                isEnabledDictionary["timetable"] == true &&
                isEnabledDictionary["emoji"] == true &&
                isEnabledDictionary["colour"] == true else {
            createButton.isEnabled = false
            createButton.backgroundColor = .yp_Gray
            return }
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlackDay
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Actions
    @objc
    private func createNewTracker() {
        guard let text = textField.text, let category = detailTextCategory else { return }
        guard let selectedEmojieIndexPath = isSelectedEmoji, let selectedColorIndexPath = isSelectedColor else { return }
        let emojie = emojies[selectedEmojieIndexPath.row]
        let color = colors[selectedColorIndexPath.row]
        
        if chooseIrregularEvent {
            let newTracker = Tracker(id: UUID(), name: text, color: color, emojie: emojie, timetable: nil)
            onTrackerCreated?(newTracker, category)
        } else {
            guard let timetabel = detailTextDays else { return }
            let newTracker = Tracker(id: UUID(), name: text, color: color, emojie: emojie, timetable: timetabel)
            onTrackerCreated?(newTracker, category)
        }
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func exitView() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isEnabledDictionary["text"] = false
        createButtonIsEnabled()
        limitLabel.isHidden = true
        setupConstraints()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count >= 38 {
            limitLabel.isHidden = false
            newConstraintsLimitLabel()
        } else {
            limitLabel.isHidden = true
            setupConstraints()
        }
        updatedText.count == 0 ? (isEnabledDictionary["text"] = false) : (isEnabledDictionary["text"] = true)
        createButtonIsEnabled()
        return updatedText.count <= 38
    }
}

// MARK: - UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chooseIrregularEvent ? (isEnabledDictionary["timatable"] = true) : (isEnabledDictionary["timatable"] = false)
        return chooseIrregularEvent ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitledTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = namesButton[indexPath.row]
        cell.backgroundColor = .ypBackgroundDay
        cell.accessoryType = .disclosureIndicator
        
        guard let detailTextLabel = cell.detailTextLabel else { return cell }
        detailTextLabel.font = UIFont.systemFont(ofSize: 17)
        detailTextLabel.textColor = .yp_Gray
        
        switch indexPath.row {
        case 0:
            (detailTextCategory?.isEmpty ?? true) ? (isEnabledDictionary["category"] = false) :
            (isEnabledDictionary["category"] = true)
            createButtonIsEnabled()
            detailTextLabel.text = detailTextCategory
        case 1:
            if let days = detailTextDays {
                if days.count == 7 {
                    detailTextLabel.text = "Каждый день"
                    isEnabledDictionary["timatable"] = true
                    createButtonIsEnabled()
                } else {
                    let orderedDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                    let sortedDays = days.sorted { first, second in
                        if let firstIndex = orderedDays.firstIndex(of: first), let secondIndex = orderedDays.firstIndex(of: second) {
                            return firstIndex < secondIndex
                        } else {
                            return false
                        }
                    }
                    let daysText = sortedDays.joined(separator: ", ")
                    detailTextLabel.text = daysText
                    
                    (daysText.isEmpty) ?  (isEnabledDictionary["timatable"] = false) : (isEnabledDictionary["timetable"] = true)
                    createButtonIsEnabled()
                }
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDelegate
extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissKeyboard()
        if indexPath.row == 0 {
            let categoriesViewController = CategoriesViewController()
            categoriesViewController.delegate = self
            categoriesViewController.title = "Категория"
            
            let navigationController = UINavigationController(rootViewController: categoriesViewController)
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.shadowImage = UIImage()
            present(navigationController, animated: true)
        } else if indexPath.row == 1 {
            let timetableViewController = TimetableViewController()
            timetableViewController.delegate = self
            timetableViewController.title = "Расписание"
            
            let navigationController = UINavigationController(rootViewController: timetableViewController)
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.shadowImage = UIImage()
            present(navigationController, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojies.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath
            ) as? EmojiCollectionViewCell else { return UICollectionViewCell()}
            
            cell.titleLabel.text = emojies[indexPath.row]
            cell.backgroundColor = cell.isSelected ? .ypBackgroundDay : .clear
           
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorsCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorsCollectionViewCell else { return UICollectionViewCell()}
            
            cell.sizeToFit()
            cell.colorView.backgroundColor = colors[indexPath.row]
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()
        if indexPath.section == 0 {
            if let selectedCell = isSelectedEmoji {
                let cell = collectionView.cellForItem(at: selectedCell)
                cell?.backgroundColor = .clear
            }
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 10
            cell?.backgroundColor = .yp_LightGray
            isSelectedEmoji = indexPath
            isEnabledDictionary["emoji"] = true
            createButtonIsEnabled()
        } else if indexPath.section == 1 {
            if let selectedCell = isSelectedColor {
                let cell = collectionView.cellForItem(at: selectedCell)
                cell?.layer.borderWidth = 0
                cell?.layer.borderColor = .none
            }
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 10
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = UIColor.colorSelection[indexPath.row].withAlphaComponent(0.3).cgColor
            isSelectedColor = indexPath
            isEnabledDictionary["colour"] = true
            createButtonIsEnabled()
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        if indexPath.section == 0 {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? HeaderViewCell else { return UICollectionReusableView()}
            view.titleLabel.text = "Emoji"
            return view
        } else {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? HeaderViewCell else { return UICollectionReusableView()}
            view.titleLabel.text = "Цвет"
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - HabitDelegate
extension NewTrackerViewController: HabitDelegate {
    func addDetailCategory(_ text: String) {
        detailTextCategory = text
        tableView.reloadData()
    }
    
    func addDetailDays(_ days: [String]) {
        detailTextDays = days
        tableView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension NewTrackerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - SetupViews
private extension NewTrackerViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.delegate = self
        contentView.addSubviews(textFieldStackView, tableView, collectionView, buttonStackView)
        
        collectionViewHeightContraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height),
            tableView.topAnchor.constraint(equalTo: limitLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            collectionViewHeightContraint,
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    func newConstraintsLimitLabel() {
        setupConstraints()
        NSLayoutConstraint.activate([
            limitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            limitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func updateCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        collectionViewHeightContraint.constant = collectionView.contentSize.height
    }
}
