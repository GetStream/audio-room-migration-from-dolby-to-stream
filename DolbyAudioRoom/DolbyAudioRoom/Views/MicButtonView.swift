//
//  MicButtonView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI

struct MicButtonView: View {

    @ObservedObject var viewModel: VoxeetSDKViewModel

    var body: some View {
        if viewModel.hasActiveCall {
            Button {
                viewModel.toggleAudio()
            } label: {
                Image(systemName: viewModel.isMuted ? "mic.slash.circle" : "mic.circle")
                    .foregroundColor(viewModel.isMuted ? .red : .primary)
                    .font(.title)
            }
        } else {
            EmptyView()
        }
    }
}
