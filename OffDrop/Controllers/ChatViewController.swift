//
//  ViewController.swift
//  OffDrop
//
//  Created by Can Altay on 30.07.2025.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {
    private var  mpcManager: MPCManager!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        super.viewDidLoad()
        guard let text = messageTextField.text, !text.isEmpty else { return }

        mpcManager.send(message: text)
        appendMessage("\(text)")
        messageTextField.text = ""
    }
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mpcManager = MPCManager()
        mpcManager.start()
        
        messageTextView.isEditable = false
        mpcManager.onMessageReceived = {[weak self] sender, message in
            DispatchQueue.main.async {
                self?.appendMessage("\(sender): \(message)")
            }
        }
        messageTextField.delegate = self
        registerForKeyboardNotifications()

    }

    private func appendMessage(_ message: String) {
            messageTextView.text += message + "\n"
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
}

