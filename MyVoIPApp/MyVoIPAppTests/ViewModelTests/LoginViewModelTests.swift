//
//  LoginViewModelTests.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import XCTest
@testable import MyVoIPApp
import AgoraRtcKit

import XCTest
import Combine
@testable import MyVoIPApp

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var firebaseService: MockFirebaseService!
    var agoraService: AgoraServiceMock!
    var coreDataStack: CoreDataStack!

}


class AgoraServiceMock: AgoraService {
    var shouldJoinChannelSucceed = true
    var shouldLeaveChannelSucceed = true
    
    override func joinChannel(channelID channelName: String, token: String?, uid: UInt, completion: @escaping (Bool) -> Void) {
        completion(shouldJoinChannelSucceed)
    }
    
    override func leaveChannel(completion: @escaping (Bool) -> Void) {
        completion(shouldLeaveChannelSucceed)
    }
}
