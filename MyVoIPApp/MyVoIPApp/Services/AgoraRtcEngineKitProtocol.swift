//
//  AgoraRtcEngineKitProtocol.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import AgoraRtcKit

protocol AgoraRtcEngineKitProtocol {
    static func sharedEngine(withAppId appId: String, delegate: AgoraRtcEngineDelegate?) -> AgoraRtcEngineKit
    func joinChannel(byToken token: String?, channelId: String, info: String?, uid: UInt, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32
    func leaveChannel(_ leaveChannelBlock: ((AgoraChannelStats) -> Void)?) -> Int32
    func enableAudio() -> Int32
    func setChannelProfile(_ profile: AgoraChannelProfile) -> Int32
    func setClientRole(_ role: AgoraClientRole) -> Int32
    func stopPreview() -> Int32
    func muteLocalAudioStream(_ mute: Bool) -> Int32
    func setEnableSpeakerphone(_ enabled: Bool) -> Int32
    var delegate: AgoraRtcEngineDelegate? { get set }
}

extension AgoraRtcEngineKit: AgoraRtcEngineKitProtocol {}
