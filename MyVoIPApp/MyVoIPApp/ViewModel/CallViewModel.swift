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
    private let firebaseService: FirebaseService
    
    private(set) var isMuted: Bool = false
    private(set) var isSpeakerOn: Bool = true
    
    var activeUsers: UInt = 0
    var onActiveUsersChanged: (() -> Void)?
    
    @Published var isJoiningChannel = false
    @Published var joinedChannel = false
    @Published var errorMessage = ""
    
    // The set of all users in the channel.
    @Published public var allUsers: Set<UInt> = []
    
    init(agoraService: AgoraService, firebaseService: FirebaseService) {
        self.agoraService = agoraService
        self.firebaseService = firebaseService
    }
    
    func prepareForCall(withUser user: UserEntity) {
        self.user = user

        agoraService.onInitialized = { [weak self] in
            self?.joinChannel(channelName: String.channelName, token: String.channelToken, uid: UInt((self?.user?.userid)!))
        }
        
        agoraService.onUserJoined = { [weak self] uid in
            self?.activeUsers += 1
            self?.onActiveUsersChanged?()
        }
        agoraService.onUserLeft = { [weak self] uid in
            self?.activeUsers -= 1
            self?.onActiveUsersChanged?()
        }
        
        agoraService.initializeAgoraEngine(AgoraRtcEngineKit.agoraEngine(withDelegate: nil))

    }
    
    func exitCall(completion: @escaping (Bool) -> Void) {
        agoraService.leaveChannel() { [weak self] success in
            if success {
                self?.firebaseService.removeUser(username: self?.user?.username ?? " ") { _, _ in // apply some logic}
                }
            }
            
            completion(success)
        }
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
        
        firebaseService.registerUser(username: (user?.username!)!) { [weak self] id, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self?.agoraService.joinChannel(channelID: channelName, token: token, uid: uid) { [weak self] success in
                        DispatchQueue.main.async {
                            self?.isJoiningChannel = false
                            
                            if success {
                                self?.joinedChannel = true
                                self?.activeUsers += 1
                                self?.onActiveUsersChanged?()
                            } else {
                                self?.errorMessage = "Failed to join channel"
                            }
                        }
                    }
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
