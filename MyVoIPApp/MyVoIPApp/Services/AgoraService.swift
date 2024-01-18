//
//  AgoraService.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import AgoraRtcKit

class AgoraService {
    private var agoraEngine: AgoraRtcEngineKitProtocol?
    var onInitialized: (() -> Void)?

    func setupAgoraEngine(delegate: AgoraRtcEngineDelegate) {
        self.agoraEngine = AgoraRtcEngineKit.agoraEngine(withDelegate: nil)
        
        _ = self.agoraEngine?.enableAudio()
        _ = self.agoraEngine?.setClientRole(.broadcaster)
        _ = self.agoraEngine?.setChannelProfile(.communication)
        
        onInitialized?()
    }

    func joinChannel(channelID: String, token: String?, uid: UInt, completion: @escaping (Bool) -> Void) {
        let errorCode = agoraEngine?.joinChannel(byToken: token, channelId: channelID, info: nil, uid: uid) { string, _, _ in
            completion(true)
        }
        if errorCode != 0 {
            completion(false)
        }
    }
    
    func stopPreview(completion: @escaping (Bool) -> Void) {
        let errorCode = agoraEngine?.stopPreview()
        if errorCode != 0 {
            completion(false)
        }
    }
    
    func muteLocalAudioStream(mute: Bool) {
        _ = agoraEngine?.muteLocalAudioStream(mute)
    }
    
    func setEnableSpeakerphone(enableSpeaker: Bool) {
        _ = agoraEngine?.setEnableSpeakerphone(enableSpeaker)
    }
    
    func leaveChannel(completion: @escaping (Bool) -> Void) {
        let errorCode = agoraEngine?.leaveChannel { stats in
            // Handle stats if needed, e.g., calculate call duration
            completion(true)
        }
        if errorCode != 0 {
            completion(false)
        }
    }
}
