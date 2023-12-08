//
//  ParticipantsView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI

struct ParticipantsView: View {
    @ObservedObject var viewModel: VoxeetSDKViewModel

    var body: some View {
        if viewModel.hasActiveCall {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(viewModel.participants, id: \.info) {
                    ParticipantView(participant: $0, viewModel: viewModel)
                }
            }
        }
    }
}
