//
//  AgoraServiceTests.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import XCTest
@testable import MyVoIPApp

import XCTest
@testable import MyVoIPApp

class AgoraServiceTests: XCTestCase {
    var agoraService: AgoraService!
    var mockAgoraKit: MockAgoraRtcEngineKit!

    override func setUp() {
        super.setUp()
        mockAgoraKit = MockAgoraRtcEngineKit()
        agoraService = AgoraService()
    }

    override func tearDown() {
        agoraService = nil
        mockAgoraKit = nil
        super.tearDown()
    }

    func testJoinChannelSuccess() {
        mockAgoraKit.shouldJoinChannelSucceed = true
        agoraService.joinChannel(channelID: "testChannel", token: "testToken", uid: 123) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockAgoraKit.joinChannelCallCount, 1)
        }
    }

    func testLeaveChannelSuccess() {
        mockAgoraKit.shouldLeaveChannelSucceed = true
        agoraService.leaveChannel { success in
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockAgoraKit.leaveChannelCallCount, 1)
        }
    }
}
