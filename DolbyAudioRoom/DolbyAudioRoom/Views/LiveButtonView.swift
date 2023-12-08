//
//  LiveButtonView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI

struct LiveButtonView: View {

    @ObservedObject var viewModel: VoxeetSDKViewModel
    @State private var error: Error?

    var body: some View {
        if viewModel.hasActiveCall {
            Button {
                Task {
                    viewModel.leave()
                }
            } label: {
                Text("Leave")
            }
            .buttonStyle(.borderedProminent).tint(.red)
        } else {
            Button {
                Task {
                    do {
                        try await viewModel.connectUser(
                            name: "Obi-Wan Kenobi",
                            avatarURL: "https://picsum.photos/120"
                        )
                        try await viewModel.joinCall()
                    } catch {
                        self.error = error
                    }
                }
            } label: {
                Text("Join")
            }
            .alert(isPresented: .constant(error != nil), content: {
                Alert(
                    title: Text("Oops.."),
                    message: error.map { Text($0.localizedDescription) },
                    dismissButton: .default(Text("OK"), action: { error = nil })
                )
            })
        }
    }
}
