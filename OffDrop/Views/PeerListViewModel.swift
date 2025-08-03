//
//  PeerListViewModel.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 2.08.2025.
//

import MultipeerConnectivity

final class PeerListViewModel: NSObject {
    private lazy var peerID: MCPeerID = MCPeerID(displayName: UserDefaults.standard.string(forKey: "username") ?? UIDevice.current.name)

    private lazy var session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    private lazy var browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "mpc-chat-demo")

    var foundPeers: [MCPeerID] = []

    var onPeersUpdated: (() -> Void)?
    var onConnected: ((MCSession) -> Void)?
    var hasAlreadyNavigated = false
    let mpcManager = MPCManager.shared

    override init() {
        super.init()
        session.delegate = self
        browser.delegate = self
        mpcManager.start()
    }

    func startBrowsing() {
        browser.startBrowsingForPeers()
    }

    func invite(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
    }

    func getSession() -> MCSession {
        return session
    }
    
}

