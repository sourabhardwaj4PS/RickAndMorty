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
    @State private var hasAppeared = false
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    public var body: some View {
        ScrollView {
            if viewModel.finishedLoading {
                ImageView(imageUrlString: viewModel.image)
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)
                    .aspectRatio(contentMode: .fit)
                    .background(Color.gray.opacity(0.1))
                    .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.image)

                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.name)
                    
                    TitleLabelView(title: "\(AttributeLabels.species.rawValue):", label: viewModel.species)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.species)
                    
                    TitleLabelView(title: "\(AttributeLabels.status.rawValue):", label: viewModel.status)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.status)
                    
                    TitleLabelView(title: "\(AttributeLabels.gender.rawValue):", label: viewModel.gender)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.gender)
                    
                    TitleLabelView(title: "\(AttributeLabels.birth.rawValue):", label: viewModel.created)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.birth)

                    Text("\(AttributeLabels.episodesAired.rawValue):")
                        .font(.headline)
                        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.episodes)
                    
                    ForEach(viewModel.episode.indices, id: \.self) { index in
                        let episode = viewModel.episode[index]
                        Text(episode)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
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
            guard !hasAppeared else { return }
            hasAppeared.toggle()
            
            viewModel.loadCharacterDetails(id: viewModel.characterId)
        })
        .alert(CharacterConstants.Titles.Alerts.somethingWentWrong, isPresented: $viewModel.isServerError, actions: {
            Button(CharacterConstants.Titles.Buttons.ok) {
                viewModel.loadCharacterDetails(id: viewModel.characterId)
            }
            Button(CharacterConstants.Titles.Buttons.cancel, role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? CharacterConstants.Titles.Alerts.somethingWentWrong)
        })
    }
}



/*#Preview {
    let detailsVM = CharacterDetailsViewModelImpl(characterId: 2)
    detailsVM.loadCharacterDetails(id: 2)
    CharacterDetailsView(viewModel: detailsVM)
}*/
