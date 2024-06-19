//
//  CharacterDetailsView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import SwiftUI

struct CharacterDetailsView<T>: View where T: CharacterDetailsViewModel {
    
    @StateObject var viewModel: T
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = StateObject(wrappedValue: viewModel())
        print("CharacterDetailsView init")
    }
    
    public var body: some View {
        ScrollView {
            if viewModel.finishedLoading {
                VStack(alignment: .leading, spacing: 16) {
                    ImageView(imageUrlString: viewModel.image)
                        .frame(maxWidth: .infinity, maxHeight: 360)
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .accessibilityIdentifier("image")
                    
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .accessibilityIdentifier("name")
                    
                    TitleLabelView(title: "Species:", label: viewModel.species)
                        .accessibilityIdentifier("title")
                    
                    TitleLabelView(title: "Status:", label: viewModel.status)
                        .accessibilityIdentifier("status")
                    
                    TitleLabelView(title: "Gender:", label: viewModel.gender)
                        .accessibilityIdentifier("gender")
                    
                    TitleLabelView(title: "Birth:", label: viewModel.created)
                        .accessibilityIdentifier("birth")

                    Text("Episodes Aired:")
                        .font(.headline)
                        .accessibilityIdentifier("episodes")
                    
                    ForEach(viewModel.episode.indices, id: \.self) { index in
                        let episode = viewModel.episode[index]
                        Text(episode)
                    }
                }
                .accessibilityElement(children: .contain)
            }
            else {
                ProgressView()
            }
        }
        .padding(8)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("characterDetailsView")
        .navigationBarTitle("In depth", displayMode: .inline)
        .onAppear(perform: {
            Task {
                await viewModel.loadCharacterDetails(id: viewModel.characterId)
            }
        })
        .alert("Characters", isPresented: $viewModel.isServerError, actions: {
            Button("Retry") {
                Task {
                    await viewModel.loadCharacterDetails(id: viewModel.characterId)
                }
            }
            Button("Cancel", role: .cancel) {
                print("alert tapped")
            }
        }, message: {
            Text(viewModel.errorMessage)
        })
    }
}



//#Preview {
//    CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: 3))
//}
