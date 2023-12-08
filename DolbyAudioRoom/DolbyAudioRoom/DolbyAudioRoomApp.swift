//
//  DolbyAudioRoom.swift
//  DolbyAudioRoom
//

import SwiftUI
import VoxeetSDK
import Combine

@main
struct DolbyAudioRoomApp: App {
    private static let token: String = "THE_YOU_GOT_TOKEN_FROM_DASHBOARD"
    private static let callId: String = "A_CALLID_THAT_CAN_BE_USED_WITH_THE_PROVIDED_TOKEN"

    @StateObject private var viewModel: VoxeetSDKViewModel

    init() {
        self._viewModel = .init(wrappedValue: .init(Self.token, callId: Self.callId))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
