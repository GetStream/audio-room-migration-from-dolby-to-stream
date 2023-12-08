//
//  ParticipantView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI
import VoxeetSDK

struct ParticipantView: View {
    var participant: VTParticipant
    let viewModel: VoxeetSDKViewModel

    @State private var isSpeaking = false

    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .fill(isSpeaking ? .green : .white)
                    .frame(width: 68, height: 68)
                    .overlay(
                        AsyncImage(
                            url: .init(string: participant.info.avatarURL ?? ""),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 64, maxHeight: 64)
                                    .clipShape(Circle())
                            },
                            placeholder: {
                                Image(systemName: "person.crop.circle").font(.system(size: 60))
                            }
                        )
                    )
            }
            if participant == viewModel.localParticipant {
                Text("\(participant.info.name ?? "N/A")(You)")
            } else {
                Text("\(participant.info.name ?? "N/A")")
            }
        }
        .onReceive(viewModel.$speakingParticipants) { speakingParticipants in
            isSpeaking = speakingParticipants.first { $0.id != nil && $0.id == participant.id } != nil
        }
    }
}

