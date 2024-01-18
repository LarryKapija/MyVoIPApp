//
//  VoIPService.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 18/1/24.
//

import Foundation
import CallKit
import UIKit

class VoIPService: NSObject, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    private let provider: CXProvider

    override init() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "MyVoIPApp")
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        return providerConfiguration
    }

    func reportIncomingCall(uuid: UUID, handle: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.hasVideo = true // or false, as appropriate

        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("Failed to report incoming call: \(error)")
            } else {
                print("Incoming call reported.")
            }
        }
    }
}
