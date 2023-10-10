//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Руслан  on 04.09.2023.
//

import UIKit

final class AddNewCategoryViewController: UIViewController {
    var isEdit: Bool = false
    var editText: String?
    
    weak var delegate: AddNewСategoryViewControllerDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        textField.leftViewMode = .always
        textField.placeholder = LocalizableKeys.addNewCategoryTextField
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.becomeFirstResponder()
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableKeys.addNewCategoryDoneButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yp_Gray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = isEdit ? LocalizableKeys.addNewCategoryNew : LocalizableKeys.addNewCategoryEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        editCategory()
        setupTapGestureToDismissKeyboard()
    }
    
    // MARK: Selectors
    @objc
    private func saveCategory() {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if isEdit {
            delegate?.editCategory(text)
        } else {
            delegate?.addCategory(text)
        }
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) 
    }
    
    // MARK: EditCategory
    private func editCategory() {
        if isEdit {
            textField.text = editText
            doneButton.backgroundColor = .ypBlackDay
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.isEnabled = true
        }
    }
    
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

}
    // MARK: - UITextFieldDelegate
extension AddNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if newText.isEmpty || newText.first == " " {
            doneButton.backgroundColor = .yp_Gray
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.isEnabled = false
            return newText != " "
        } else {
            doneButton.backgroundColor = .ypBlackDay
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.isEnabled = true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            doneButton.backgroundColor = .yp_Gray
            doneButton.setTitleColor(.white, for: .normal)
        }
    }
}

// MARK: - SetupViews
extension AddNewCategoryViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(textField, doneButton)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
