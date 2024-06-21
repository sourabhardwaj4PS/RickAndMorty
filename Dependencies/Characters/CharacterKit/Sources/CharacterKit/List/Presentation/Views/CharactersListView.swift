//
//  CharactersListView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import SwiftUI

public struct CharactersListView<T>: View where T: CharactersViewModel {
    
    // MARK: - Properties
    @StateObject var viewModel: T
    @State private var selectedCharacterId: Int?
    @State private var navigateToDetails = false
    @State private var hasAppeared = false
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Content View
    public var body: some View {
        NavigationView {
            if viewModel.characters.isEmpty {
                ProgressView()
            }
            else {
                populateListView()
                    .background(content: {
                        // avoids initialization of destination view for every row (in the list) even before tapping
                        NavigationLink(
                            destination: destinationView,
                            isActive: $navigateToDetails,
                            label: { EmptyView() }
                        )
                    })
                    .alert(CharacterConstants.Titles.Alerts.somethingWentWrong, isPresented: $viewModel.isServerError, actions: {
                        Button(CharacterConstants.Titles.Buttons.retry) {
                            viewModel.loadCharacters()
                        }
                        Button(CharacterConstants.Titles.Buttons.cancel, role: .cancel) { }
                    }, message: {
                        Text(viewModel.errorMessage ?? CharacterConstants.Titles.Alerts.somethingWentWrong)
                    })
            }
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared.toggle()
            
            viewModel.loadCharacters()
        }
    }
    
    @ViewBuilder
    private func populateListView() -> some View {
        List(viewModel.characters, id: \.name) { character in
            if let characterVM = character as? CharacterViewModelImpl {
                
                // create row view
                CharacterRowView(viewModel: characterVM)
                    .onAppear {
                        if characterVM == (viewModel.characters.last as? CharacterViewModelImpl) {
                            viewModel.loadMore()
                        }
                    }
                    .onTapGesture {
                        // store the tapped character Id and trigger navigation using state variable
                        selectedCharacterId = characterVM.id
                        navigateToDetails = true
                    }
            }
        }
        .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.listView)
        .navigationTitle(CharacterConstants.Titles.Page.characters)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if let characterId = selectedCharacterId {
            CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: characterId))
        } else {
            EmptyView()
        }
    }
}

/*#Preview {
    CharactersListView(viewModel: PreviewCharactersViewModelImpl())
}*/
