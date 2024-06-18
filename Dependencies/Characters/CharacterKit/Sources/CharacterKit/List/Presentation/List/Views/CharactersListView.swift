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
                    // NavigationLink to the CharacterDetailsView
                    if let modelVM = viewModel.character as? CharacterViewModelImpl {
                        NavigationLink(destination: CharacterDetailsView(viewModel: modelVM),
                                       isActive: $viewModel.navigateToDetails) {
                           EmptyView()
                       }
                    }
                    
                    // loop characters to make RowViews
                    ForEach(viewModel.characters.indices, id: \.self) { index in
                        let character = viewModel.characters[index]

                        // FIXME: see why below is not working.. it has to work.
                        //CharacterRowView(viewModel: characterVM)
                        
                        // FIXME: VERY VERY BAD APPROACH !!
                        let characterVM = CharacterViewModelImpl(character: character.character)
                                                
//                        NavigationLink(destination: CharacterDetailsView(viewModel: characterVM)) {
                            CharacterRowView(viewModel: characterVM)
                                .accessibilityIdentifier("rowView-\(characterVM.character.id)")
                                .onAppear {
                                    if viewModel.shouldLoadMore(index: index) {
                                        Task {
                                            await viewModel.loadMore()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.tappedCharacter(id: character.character.id)
                                }
//                        }
                    }
                }
                .accessibilityIdentifier("charactersListView")
                .navigationTitle("Characters")
                .listStyle(.plain)
            }
        }
    }
}

/*#Preview {
    CharactersListView(viewModel: PreviewCharactersViewModelImpl())
}*/
