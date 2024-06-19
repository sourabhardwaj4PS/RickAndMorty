//
//  CharactersListView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import SwiftUI

public struct CharactersListView<T>: View where T: CharactersViewModel {
    
    @StateObject var viewModel: T
    @State private var selectedCharacterId: Int?
    @State private var navigateToDetails = false
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    public var body: some View {
        NavigationView {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                ProgressView()
            }
            else {
                List {
                    ForEach(viewModel.characters.indices, id: \.self) { index in
                        if let characterVM = viewModel.characters[index] as? CharacterViewModelImpl {
                            
                            // create row view
                            CharacterRowView(viewModel: characterVM)
                                .onAppear {
                                    // validates the current index with total number of characters
                                    if viewModel.shouldLoadMore(index: index) {
                                        Task {
                                            await viewModel.loadMore()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    // store the tapped character Id and trigger navigation using state variable
                                    selectedCharacterId = characterVM.id
                                    navigateToDetails = true
                                }
                        }
                    }
                }
                .accessibilityIdentifier(CharacterConstants.AccessibilityIdentifiers.listView)
                .navigationTitle(CharacterConstants.Titles.Page.characters)
                .listStyle(.plain)
                .alert(CharacterConstants.Titles.Alerts.somethingWentWrong, isPresented: $viewModel.isServerError, actions: {
                    Button(CharacterConstants.Titles.Buttons.retry) {
                        Task {
                            await viewModel.loadCharacters()
                        }
                    }
                    Button(CharacterConstants.Titles.Buttons.cancel, role: .cancel) { }
                }, message: {
                    Text(viewModel.errorMessage)
                })
                .background(content: {
                    // avoids initialization of destination view for every row (in the list) even before tapping
                    NavigationLink(
                        destination: destinationView,
                        isActive: $navigateToDetails,
                        label: { EmptyView() }
                    )
                })
            }
        }
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
