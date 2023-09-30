//
//  UIViewController.swift
//  Tracker
//
//  Created by Руслан  on 22.09.2023.
//

import UIKit

extension UIViewController {
    // MARK: Properties
    var hideKeyboardWhenClicked: UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboardWhenClicked))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        return tap
    }
    // MARK: Selector
    @objc func dismissKeyboardWhenClicked() {
        view.endEditing(true)
    }
    // MARK: Functions
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
