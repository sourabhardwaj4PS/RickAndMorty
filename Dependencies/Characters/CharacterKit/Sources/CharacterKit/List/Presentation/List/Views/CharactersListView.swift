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
                                .accessibilityIdentifier("rowView-\(characterVM.id)")
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

                            
                            
                            
//                            NavigationLink(
//                                destination: CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: selectedCharacterId ?? 0)),
//                                tag: characterVM.id,
//                                selection: $selectedCharacterId
//                            ) {
//                                CharacterRowView(viewModel: characterVM)
//                                    .accessibilityIdentifier("rowView-\(characterVM.id)")
//                                    .onAppear {
//                                        if viewModel.shouldLoadMore(index: index) {
//                                            Task {
//                                                await viewModel.loadMore()
//                                            }
//                                        }
//                                    }
//                                    .onTapGesture {
//                                        selectedCharacterId = characterVM.id
//                                    }
//                            }
                            
                            
//                            NavigationLink(
//                                destination: {
//                                    // Lazy-initialize the view model when the navigation link is tapped
//                                    if let characterId = characterVM.id {
//                                        CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: characterVM.id))
//                                    } else {
//                                        EmptyView()
//                                    }
//                                }(),
//                                label: {
//                                    CharacterRowView(viewModel: characterVM)
//                                        .accessibilityIdentifier("rowView-\(characterVM.id)")
//                                        .onAppear {
//                                            if viewModel.shouldLoadMore(index: index) {
//                                                Task {
//                                                    await viewModel.loadMore()
//                                                }
//                                            }
//                                        }
//                                }
//                            )
                            
                            
//                            NavigationLink(destination: CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: characterVM.id))) {
//                                CharacterRowView(viewModel: characterVM)
//                                    .accessibilityIdentifier("rowView-\(characterVM.id)")
//                                    .onAppear {
//                                        if viewModel.shouldLoadMore(index: index) {
//                                            Task {
//                                                await viewModel.loadMore()
//                                            }
//                                        }
//                                    }                               
//                            }
                            
//                        }
//                            
//                            NavigationLink(
//                                destination: CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: characterVM.id)),
//                                label: {
//                                    CharacterRowView(viewModel: characterVM)
//                                        .accessibilityIdentifier("rowView-\(characterVM.id)")
//                                        .onAppear {
//                                            if viewModel.shouldLoadMore(index: index) {
//                                                Task {
//                                                    await viewModel.loadMore()
//                                                }
//                                            }
//                                        }                                }
//                            )
//                            NavigationLink(
//                                destination: CharacterDetailsView(viewModel: CharacterDetailsViewModelImpl(characterId: characterVM.id))
//                            ) {
//                                CharacterRowView(viewModel: characterVM)
//                                    .accessibilityIdentifier("rowView-\(characterVM.id)")
//                                    .onAppear {
//                                        if viewModel.shouldLoadMore(index: index) {
//                                            Task {
//                                                await viewModel.loadMore()
//                                            }
//                                        }
//                                    }
//                            }
                        }
                        else {
                            Text("Not able to parse View Model in Listing View")
                        }
                    }
                }
                .accessibilityIdentifier("charactersListView")
                .navigationTitle("Characters")
                .listStyle(.plain)
                .alert("Characters", isPresented: $viewModel.isServerError, actions: {
                    Button("Retry") {
                        Task {
                            await viewModel.loadCharacters()
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        print("alert tapped")
                    }
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
                
//                if let selected = viewModel.tappedCharacterId {
//                    let detailsVM = CharacterDetailsViewModelImpl(characterId: selected)
//                    let detailsView = CharacterDetailsView(viewModel: detailsVM)
//
//                    NavigationLink(
//                        destination: detailsView,
//                        isActive: $viewModel.navigateToDetails,
//                        label: {
//                            EmptyView()
//                        }
//                    )
//                }
                
            }
        }
    }
}

/*#Preview {
    CharactersListView(viewModel: PreviewCharactersViewModelImpl())
}*/
