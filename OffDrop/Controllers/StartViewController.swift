//
//  StartViewController.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 3.08.2025.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        textField.delegate = self
        addTapGestureToDismissKeyboard()
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)

    }
    

    @IBOutlet weak var continueButton: UIButton!
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        view.frame.origin.y = view.frame.origin.y-keyboardHeight
    }


    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleContinue() {
      
        guard let name = self.textField.text, !name.isEmpty else { return }
        UserDefaults.standard.set(name, forKey: "username")
        textField.text = ""
        MPCManager.shared = MPCManager()
        let peerListVC = PeerListViewController.instantiate()
        self.navigationController?.pushViewController(peerListVC, animated: true)
        
    }



}
