//
//  PeerListViewController.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 2.08.2025.
//

import UIKit
import MultipeerConnectivity

class PeerListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = PeerListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cihaz Seç"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // ViewModel sıfırla
        self.viewModel = PeerListViewModel()
        
        self.viewModel.onPeersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        self.viewModel.onConnected = { [weak self] session in
            DispatchQueue.main.async {
                let chatVC = ChatViewController.instantiate()
                chatVC.peerListViewModel = self?.viewModel
                self?.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
        self.tableView.reloadData()
        self.viewModel.startBrowsing()
    }
    
}

extension PeerListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.foundPeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peer = viewModel.foundPeers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeerCell") ?? UITableViewCell(style: .default, reuseIdentifier: "PeerCell")
        cell.textLabel?.text = peer.displayName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = viewModel.foundPeers[indexPath.row]
        viewModel.invite(peer: selectedPeer)
    }
}
