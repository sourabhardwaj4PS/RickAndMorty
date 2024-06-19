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
                            
                            CharacterRowView(viewModel: characterVM)
                                .onAppear {
                                    if viewModel.shouldLoadMore(index: index) {
                                        Task {
                                            await viewModel.loadMore()
                                        }
                                    }
                                }
                                .onTapGesture {
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
                .background(
                    NavigationLink(
                        destination: CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: selectedCharacterId ?? 1)),
                        isActive: $navigateToDetails
                    ) {
                        EmptyView()
                    }
                )
            }
        }
    }
}

/*#Preview {
    CharactersListView(viewModel: PreviewCharactersViewModelImpl())
}*/
