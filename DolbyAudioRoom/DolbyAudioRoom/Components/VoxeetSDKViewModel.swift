//
//  VoxeetSDKViewModel.swift
//  DolbyAudioRoom
//
//  Created by Ilias Pavlidakis on 8/12/23.
//

import Foundation
import VoxeetSDK
import SwiftUI
import Combine

final class VoxeetSDKViewModel: ObservableObject, VTConferenceDelegate {

    @Published var participants: [VTParticipant] = []
    @Published var isMuted: Bool = false
    @Published var speakingParticipants: [VTParticipant] = []
    @Published var hasActiveCall = false {
        didSet {
            if hasActiveCall {
                speakingParticipantsCancellable = Timer
                    .publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .receive(on: DispatchQueue.global(qos: .userInteractive))
                    .sink { [weak self] _ in self?.updateSpeakingParticipants() }
            } else {
                speakingParticipantsCancellable?.cancel()
            }
        }
    }

    var localParticipant: VTParticipant? { VoxeetSDK.shared.session.participant }

    private var speakingParticipantsCancellable: AnyCancellable?
    let callId: String

    init(_ token: String, callId: String) {
        self.callId = callId
        VoxeetSDK.shared.initialize(accessToken: token) { [token] closure, isExpired in
            closure(token)
        }

        VoxeetSDK.shared.notification.push.type = .none
        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = true
        VoxeetSDK.shared.conference.defaultVideo = false

        VoxeetSDK.shared.conference.delegate = self
    }

    @discardableResult
    func connectUser(name: String, avatarURL: String? = nil) async throws -> VTParticipantInfo {
        try await withUnsafeThrowingContinuation { continuation in
            let user = VTParticipantInfo(
                externalID: UUID().uuidString,
                name: name,
                avatarURL: avatarURL
            )

            VoxeetSDK.shared.session.open(info: user) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: user)
                }
            }
        }
    }

    @discardableResult
    func joinCall() async throws -> VTConference {
        try await withUnsafeThrowingContinuation { continuation in
            let options = VTConferenceOptions()
            options.params.dolbyVoice = true
            options.alias = callId

            VoxeetSDK.shared
                .conference
                .create(options: options) { conference in
                    debugPrint(conference)
                    VoxeetSDK.shared
                        .conference
                        .join(conference: conference) { response in
                            debugPrint(response)
                            DispatchQueue.main.async { [weak self] in
                                self?.isMuted = VoxeetSDK.shared.conference.isMuted()
                                self?.hasActiveCall = true
                            }
                            continuation.resume(returning: conference)
                        } fail: { continuation.resume(throwing: $0) }

                } fail: { continuation.resume(throwing: $0) }
        }
    }

    func toggleAudio() {
        let newValue = !isMuted
        VoxeetSDK.shared.conference.mute(newValue) { [weak self] error in
            DispatchQueue.main.async {
                if let error {
                    debugPrint("\(error)")
                } else {
                    self?.isMuted = newValue
                }
            }
        }
    }

    func leave() {
        VoxeetSDK.shared.conference.leave { error in
            if let error {
                debugPrint("\(error)")
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.hasActiveCall = false
                }
            }
        }
    }

    func statusUpdated(status: VTConferenceStatus) {

    }

    func permissionsUpdated(permissions: [Int]) {

    }

    func participantAdded(participant: VTParticipant) {
        updateParticipants()
    }

    func participantUpdated(participant: VTParticipant) {
        updateParticipants()
    }

    func streamAdded(participant: VTParticipant, stream: MediaStream) {
        updateParticipants()
    }

    func streamUpdated(participant: VTParticipant, stream: MediaStream) {
        updateParticipants()
    }

    func streamRemoved(participant: VTParticipant, stream: MediaStream) {
        updateParticipants()
    }

    private func updateParticipants() {
        participants = VoxeetSDK.shared.conference
            .current?
            .participants
            .filter({ $0.streams.isEmpty == false }) ?? []
    }

    private func updateSpeakingParticipants() {
        let localParticipant = self.localParticipant
        let speakingParticipants = participants
            .filter {
                if $0.id != nil, $0.id == localParticipant?.id {
                    if !isMuted {
                        return VoxeetSDK.shared.conference.isSpeaking(participant: $0)
                    } else {
                        return false
                    }
                } else {
                    return VoxeetSDK.shared.conference.isSpeaking(participant: $0)
                }
            }

        DispatchQueue.main.async { [weak self] in
            self?.speakingParticipants = speakingParticipants
        }
    }
}
