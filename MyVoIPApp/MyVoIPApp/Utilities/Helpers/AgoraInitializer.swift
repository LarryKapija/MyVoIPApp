//
//  AgoraInitializer.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 15/1/24.
//

import Foundation
import AgoraRtcKit


extension AgoraRtcEngineKit {
    public static func agoraEngine(withDelegate delegate: AgoraRtcEngineDelegate?) -> AgoraRtcEngineKit {
        let engine = setupEngine(delegate: delegate)
        return engine
    }
    
    private static func setupEngine(delegate: AgoraRtcEngineDelegate?) -> AgoraRtcEngineKit {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: .appid , delegate: delegate)
        engine.enableAudio()
        engine.setClientRole(.broadcaster)
        engine.setChannelProfile(.communication)
        return engine
    }
}
