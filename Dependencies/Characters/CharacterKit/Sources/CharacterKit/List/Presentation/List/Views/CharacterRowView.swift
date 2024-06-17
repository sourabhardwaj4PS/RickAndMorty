//
//  CharacterRowView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI
import CoreKit

struct CharacterRowView<T>: View where T: CharacterViewModel {
    
    @State var viewModel: T
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = State(wrappedValue: viewModel())
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ImageView(imageUrlString: viewModel.character.image)
                .frame(width: 134, height: 134)
                .cornerRadius(5)
                .accessibility(identifier: "thumbnailView-\(viewModel.character.id)")
                .onAppear {
                    print("Setting identifier: thumbnailView-\(viewModel.character.id)")
                }
            
            AttributesView(viewModel: viewModel)
                .accessibility(identifier: "attributesView-\(viewModel.character.id)")
                .onAppear {
                    print("Setting identifier: attributesView-\(viewModel.character.id)")
                }
            
            Spacer()
        }
    }
}

#Preview {
    CharacterRowView(viewModel: CharacterViewModelImpl(
        character: CharacterImpl(
            id: 1,
            name: "Citadel of Ricks",
            status: "Alive",
            species: "Cartoon",
            type: "",
            gender: "Males",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            url: "none",
            created: "NA",
            episode: []
        ))
    )
}
