//
//  MockAgoraRtcEngineKit.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import AgoraRtcKit
@testable import MyVoIPApp

class MockAgoraRtcEngineKit: AgoraRtcEngineKit {
    var shouldJoinChannelSucceed: Bool = true
    var shouldLeaveChannelSucceed: Bool = true
    var joinChannelCallCount: Int = 0
    var leaveChannelCallCount: Int = 0
    var isAudioEnabled: Bool = false

    static func sharedEngine(withAppId appId: String, delegate: AgoraRtcEngineDelegate?) -> AgoraRtcEngineKit {
        return MockAgoraRtcEngineKit()
    }
    
    override func joinChannel(byToken token: String?, channelId: String, info: String?, uid: UInt, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32 {
        joinChannelCallCount += 1
        if shouldJoinChannelSucceed {
            DispatchQueue.main.async {
                joinSuccess?(channelId, uid, 0) // Elapsed time set to 0 for immediacy in tests
            }
            return 0 //  Simulate success
        } else {
            return -1 // Simulate an error
        }
    }


    override func leaveChannel(_ leaveChannelBlock: ((AgoraChannelStats) -> Void)?) -> Int32 {
        leaveChannelCallCount += 1
        if shouldLeaveChannelSucceed {
            DispatchQueue.main.async {
                leaveChannelBlock?(AgoraChannelStats()) // AgoraChannelStats mock if neccessary
            }
            return 0 // Simulate success
        } else {
            return -1 // Simulate an error
        }
    }

    override func enableAudio() -> Int32 {
        isAudioEnabled = true
        return 0 // Simulat que that the audios
    }

    var currentChannelProfile: AgoraChannelProfile = .communication

    override func setChannelProfile(_ profile: AgoraChannelProfile) -> Int32 {
        currentChannelProfile = profile
        return 0
    }
}
