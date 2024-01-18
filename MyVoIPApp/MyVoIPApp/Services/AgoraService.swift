//
//  AgoraService.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import AgoraRtcKit

class AgoraService: NSObject, AgoraRtcEngineDelegate {
    private var agoraEngine: AgoraRtcEngineKit?
    var onInitialized: (() -> Void)?
    var activeUsers = Set<UInt>()
    var onUserJoined: ((UInt) -> Void)?
    var onUserLeft: ((UInt) -> Void)?
    
    func initializeAgoraEngine(_ agora: AgoraRtcEngineKit) {
        self.agoraEngine = agora

        self.agoraEngine?.delegate = self
        _ = self.agoraEngine?.enableAudio()
        _ = self.agoraEngine?.setClientRole(.broadcaster)
        _ = self.agoraEngine?.setChannelProfile(.communication)

        onInitialized?()
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Channel: \(channel) with UID \(uid)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccur errorType: AgoraEncryptionErrorType) {
        print("Agora SDK error: \(errorType)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Agora SDK error: \(errorCode)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        activeUsers.insert(uid)
        onUserJoined?(uid)
    }
    

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        activeUsers.remove(uid)
        onUserLeft?(uid)
    }

    func joinChannel(channelID: String, token: String?, uid: UInt, completion: @escaping (Bool) -> Void) {
        let errorCode = agoraEngine?.joinChannel(byToken: token, channelId: channelID, info: nil, uid: uid) { _, _, _ in
            completion(true)
        }

        if let errorCode = errorCode, errorCode != 0 {
            let message = "Error joining the channel: \(errorMessage(for: errorCode))"
            print(message)
            completion(false)
        }
    }

    private func errorMessage(for code: Int32) -> String {
        switch code {
        case AgoraErrorCode.joinChannelRejected.rawValue:
            return "Join channel rejected"
        case AgoraErrorCode.tokenExpired.rawValue:
            return "Token expired"
        default:
            return "Unknown error: \(code)"
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

enum AgoraErrorCode: Int32 {
    case noError = 0
    case joinChannelRejected = 17
    case tokenExpired = 109
}
