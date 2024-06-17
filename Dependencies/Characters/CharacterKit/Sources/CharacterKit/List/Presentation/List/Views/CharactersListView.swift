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
                                    print("Setting identifier: rowView-\(characterVM.character.id)")
                                    if viewModel.shouldLoadMore(index: index) {
                                        Task {
                                            await viewModel.loadMore()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.tapped(viewModel: characterVM)
                                }
//                        }
                    }
                }
                .accessibility(identifier: "charactersListView")
                .onAppear {
                    print("Setting identifier: charactersListView")
                }
                .navigationTitle("Characters")
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    CharactersListView(viewModel: PreviewCharactersViewModelImpl())
}
