//
//  ViewController.swift
//  OffDrop
//
//  Created by Can Altay on 30.07.2025.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {
    private var viewModel: ChatViewModel!
    var peerListViewModel: PeerListViewModel!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        let username = UserDefaults.standard.string(forKey: "username") ?? "Bilinmeyen"
        let formattedMessage = "\(username): \(text)"
        viewModel.send(message: formattedMessage)
        appendMessage(text)
        messageTextField.text = ""
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        registerForKeyboardNotifications()
        messageTextField.delegate = self
        
    }
    
    
    private func setupBindings() {
            viewModel.onMessageReceived = { [weak self] sender, message in
                DispatchQueue.main.async {
                    self?.appendMessage("\(message)")
                }
            }
        //viewModel.start()
        }
    
    private func setupUI() {
        viewModel = ChatViewModel(peerListViewModel: peerListViewModel)
        messageTextView.isEditable = false
        messageTextField.delegate = self
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

