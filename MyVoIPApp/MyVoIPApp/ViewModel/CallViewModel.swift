//
//  CallViewModel.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 15/1/24.
//

import Foundation
import AgoraRtcKit
class CallViewModel {
    private var user: UserEntity?
    private let agoraService: AgoraService
    
    private(set) var isMuted: Bool = false
    private(set) var isSpeakerOn: Bool = true
    
    @Published var isJoiningChannel = false
    @Published var joinedChannel = false
    @Published var errorMessage = ""
    
    // The set of all users in the channel.
    @Published public var allUsers: Set<UInt> = []

    // Integer ID of the local user.
    @Published public var localUserId: UInt = 0
    
    init( agoraService: AgoraService) {
        self.agoraService = agoraService
        
        agoraService.onInitialized = { [weak self] in
            self?.joinChannel(channelName: .channelName, token: .channelToken, uid: UInt((self?.user?.userid)!))
        }
    }
    
    func prepareForCall(withUser user: UserEntity) {
        self.user = user
    }
    
    func setupAgoraEngine(delegate: AgoraRtcEngineDelegate) {
        agoraService.setupAgoraEngine(delegate: delegate)
    }
    
    func endCall(completion: @escaping (Bool) -> Void) {
        agoraService.leaveChannel(completion: completion)
    }
    
    func toggleMute() {
        isMuted.toggle()
        agoraService.muteLocalAudioStream(mute: isMuted)
    }
    
    func toggleSpeaker() {
        isSpeakerOn.toggle()
        agoraService.setEnableSpeakerphone(enableSpeaker: isSpeakerOn)
    }

    func joinChannel(channelName: String, token: String?, uid: UInt) {
        isJoiningChannel = true
        errorMessage = ""

        agoraService.joinChannel(channelID: channelName, token: token, uid: uid) { [weak self] success in
            DispatchQueue.main.async {
                self?.isJoiningChannel = false
                
                if success {
                    self?.joinedChannel = true
                } else {
                    self?.errorMessage = "Failed to join channel"
                }
            }
        }
    }

    func leaveChannel()  {
        agoraService.leaveChannel { [weak self] success in
            DispatchQueue.main.async {
                self?.joinedChannel = !success

                if !success {
                    self?.errorMessage = "Failed to leave channel"
                    return
                }

                self?.agoraService.stopPreview() { [weak self] success in
                    if success {
                        self?.allUsers.removeAll()
                    }
                }
            }
        }
    }

    private func handleError(message: String) {
        isJoiningChannel = false
        errorMessage = message
    }
}
