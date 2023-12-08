//
//  DescriptionView.swift
//  DolbyAudioRoom
//

import Foundation
import SwiftUI

struct DescriptionView: View {
    @ObservedObject var viewModel: VoxeetSDKViewModel
    var title: String?
    var description: String?

    var body: some View {
        VStack {
            VStack {
                Text("\(title ?? "")")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding([.bottom], 8)

                if viewModel.hasActiveCall {
                    Text("\(description ?? "")")
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding([.bottom], 4)

                    Text("\(viewModel.participants.count) participants")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing])
        }
    }
}
