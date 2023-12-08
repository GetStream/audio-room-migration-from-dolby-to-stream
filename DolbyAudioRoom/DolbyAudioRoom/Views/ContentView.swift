//
//  ContentView.swift
//  DolbyAudioRoom
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: VoxeetSDKViewModel

    var body: some View {
        VStack {
            DescriptionView(
                viewModel: viewModel,
                title: viewModel.callId,
                description: "Call Description n/a"
            )
            ParticipantsView(
                viewModel: viewModel
            )
            Spacer()
            ControlsView(viewModel: viewModel)
        }
    }
}
