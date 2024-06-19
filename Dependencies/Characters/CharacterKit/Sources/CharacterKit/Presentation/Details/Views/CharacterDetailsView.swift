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
    }
    
    public var body: some View {
        ScrollView {
            if viewModel.finishedLoading {
                VStack(alignment: .leading, spacing: 16) {
                    ImageView(imageUrlString: viewModel.image)
                        .frame(maxWidth: .infinity, maxHeight: 360)
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.image)
                    
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.name)
                    
                    TitleLabelView(title: "Species:", label: viewModel.species)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.species)
                    
                    TitleLabelView(title: "Status:", label: viewModel.status)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.status)
                    
                    TitleLabelView(title: "Gender:", label: viewModel.gender)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.gender)
                    
                    TitleLabelView(title: "Birth:", label: viewModel.created)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.birth)

                    Text("Episodes Aired:")
                        .font(.headline)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.episodes)
                    
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
        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.detailsView)
        .navigationBarTitle(CharacterConstants.Titles.Page.characterDetails, displayMode: .inline)
        .onAppear(perform: {
            Task {
                await viewModel.loadCharacterDetails(id: viewModel.characterId)
            }
        })
        .alert(CharacterConstants.Titles.Alerts.somethingWentWrong, isPresented: $viewModel.isServerError, actions: {
            Button(CharacterConstants.Titles.Buttons.ok) {
                Task {
                    await viewModel.loadCharacterDetails(id: viewModel.characterId)
                }
            }
            Button(CharacterConstants.Titles.Buttons.cancel, role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage)
        })
    }
}



//#Preview {
//    CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: 3))
//}
