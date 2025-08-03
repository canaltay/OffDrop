//
//  ChatViewModel.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 2.08.2025.
//

import Foundation
class ChatViewModel {
    private let mpcManager = MPCManager.shared
    private let peerListViewModel: PeerListViewModel

    var onMessageReceived: ((String, String) -> Void)?
    init(peerListViewModel: PeerListViewModel) {
            self.peerListViewModel = peerListViewModel
            self.mpcManager.onMessageReceived = { [weak self] sender, message in
                self?.onMessageReceived?(sender, message)
            }
        }
    func start() {
        mpcManager.start()
    }
    
    func send(message: String) {
        mpcManager.send(message: message)
    }
    
}
