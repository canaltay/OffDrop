//
//  Extensions.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 30.07.2025.
//

import MultipeerConnectivity

// Oturumla ilgili olaylar
extension MPCManager: MCSessionDelegate {
    
    // Cihaz bağlantı durumu değiştiğinde tetiklenir (bağlandı, koptu vs.)
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let status: String
        switch state {
        case .connected:
            status = "bağlandı "
        case .connecting:
            status = "bağlanıyor..."
        case .notConnected:
            status = "bağlantı kesildi "
        @unknown default:
            status = "bilinmeyen durum"
        }
        print("📡 Cihaz '\(peerID.displayName)' \(status)")
    }
    
    // Veri alındığında tetiklenir (mesaj geldi)
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else {
            print(" Gelen veri çözümlenemedi.")
            return
        }
        print("Mesaj alındı (\(peerID.displayName)): '\(message)'")
        onMessageReceived?(peerID.displayName, message)
    }

    // Diğer 3 fonksiyon şu an kullanılmadığı için boş bırakıldı
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// Yayıncı delegate: Başka bir cihaz bağlanmak istediğinde tetiklenir
extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    // Diğer cihaz bağlantı isteği gönderirse, biz kabul ederiz
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("'\(peerID.displayName)' bağlantı istiyor. Kabul ediliyor...")
        invitationHandler(true, session)
    }
}

// Tarayıcı delegate: Yakında bir cihaz bulunduğunda tetiklenir
extension MPCManager: MCNearbyServiceBrowserDelegate {
    
    // Yeni bir cihaz bulunduğunda bağlantı isteği gönderilir
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("👀 Yeni cihaz bulundu: '\(peerID.displayName)' — Bağlanılıyor...")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    // Bağlantıdan çıkan cihazlar burada raporlanır
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Cihaz kayboldu: '\(peerID.displayName)'")
    }
}
