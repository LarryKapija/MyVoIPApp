//
//  CallViewController.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 15/1/24.
//


import UIKit
import Combine
import AgoraRtcKit

class CallViewController: UIViewController, UIViewControllerProtocol, AgoraRtcEngineDelegate {

    private let viewModel: CallViewModel


    private var engine: AgoraRtcEngineKit?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.setpAgoraEngine(delegate: self)
    }
    
    
    init(viewModel: CallViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
    }
    
    func rtcEngine(
        _ engine: AgoraRtcEngineKit, didJoinChannel channel: String,
        withUid uid: UInt, elapsed: Int
    ) {
        // The delegate is telling us that the local user has successfully joined the channel.
        viewModel.localUserId = uid
        viewModel.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // The delegate is telling us that a remote user has joined the channel.
        viewModel.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // The delegate is telling us that a remote user has left the channel.
        viewModel.allUsers.remove(uid)
    }
}
