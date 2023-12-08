//
//  ControlsView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI

struct ControlsView: View {
    @ObservedObject var viewModel: VoxeetSDKViewModel

    var body: some View {
        HStack {
            MicButtonView(viewModel: viewModel)
            LiveButtonView(viewModel: viewModel)
        }
    }
}
