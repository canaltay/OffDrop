//
//  MPCManager.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 30.07.2025.
//

import Foundation
import MultipeerConnectivity

// Bu sınıf, cihazlar arası bağlantı kurmak, veri (mesaj) göndermek ve almak için tüm Multipeer Connectivity işini yapar.
final class MPCManager: NSObject {
    static var shared = MPCManager()
    
    /// Multipeer servis tipi (max 15 karakter). Aynı servis tipine sahip cihazlar birbirini görür.
    private let serviceType = "mpc-chat-demo"
    
    /// Bu cihazın kimliği. Diğer cihazlara böyle tanıtılır.
    private var peerID: MCPeerID = {
        let name = UserDefaults.standard.string(forKey: "username") ?? UIDevice.current.name
        return MCPeerID(displayName: name)
    }()
    /// Oturum (session) — Bağlantı kurulduğunda, veri gönderme ve alma buradan olur.
    internal var session: MCSession!
    
    /// Yayıncı — Bu cihazı görünür kılmak için diğer cihazlara yayın yapar.
    private var advertiser: MCNearbyServiceAdvertiser!
    
    /// Tarayıcı — Yakındaki cihazları bulmak için tarama yapar.
    private var browser: MCNearbyServiceBrowser!
    
    /// Mesaj alındığında çağrılacak fonksiyon (dışarıdan set edilir).
    var onMessageReceived: ((String, String) -> Void)?
    
    override init() {
        super.init()
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        // Bu cihaz yayın yapmaya hazırlanıyor
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        // Bu cihaz yakındaki cihazları taramaya hazırlanıyor
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
    }
    
    /// Yayın ve tarama başlatılır. Yani hem diğer cihazlara görünür olunur, hem de diğer cihazlar aranır.
    func start() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
        print(" Yayın ve tarama başlatıldı. Cihaz adı: \(peerID.displayName)")
    }
    
    /// Yayın ve tarama durdurulur.
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        print(" Yayın ve tarama durduruldu.")
    }
    
    /// Bağlantı kurulu olan cihazlara mesaj gönderir.
    /// - Parameter message: Gönderilecek metin mesajı
    func send(message: String) {
        guard let data = message.data(using: .utf8) else {
            print(" Mesaj UTF-8'e çevrilemedi.")
            return
        }
        
        if session.connectedPeers.isEmpty {
            print("Bağlı peer yok, mesaj gönderilemedi.")
            return
        }
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            print("Mesaj gönderildi: '\(message)'")
        } catch {
            print("Mesaj gönderilemedi: \(error.localizedDescription)")
        }
    }
    
    public func getPeerId() -> MCPeerID {
        return self.peerID
    }
}



