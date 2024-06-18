//
//  AttributesView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI

struct AttributesView<T>: View where T: CharacterViewModel {
    
    @State var viewModel: T
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = State(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            TitleLabelView(title: "Name:", label: viewModel.character.name)
                .accessibilityIdentifier("name-\(viewModel.character.id)")
            
            TitleLabelView(title: "Gender:", label: viewModel.character.gender)
                .accessibilityIdentifier("gender-\(viewModel.character.id)")
            
            TitleLabelView(title: "Status:", label: viewModel.character.status)
                .accessibilityIdentifier("status-\(viewModel.character.id)")

            TitleLabelView(title: "Species:", label: viewModel.character.species)
                .accessibilityIdentifier("species-\(viewModel.character.id)")
            
            TitleLabelView(title: "No of episodes:", label: "\(viewModel.character.episode.count)")
                .accessibilityIdentifier("episodes-\(viewModel.character.id)")
        })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("attributesView-\(viewModel.character.id)")
        .padding(8)
    }
}

#Preview {
    AttributesView(viewModel: CharacterViewModelImpl(
        character: CharacterImpl(
            id: 1,
            name: "Rick n Morty", 
            status: "Alive",
            species: "Cartoon",
            type: "",
            gender: "Males",
            image: "some url",
            url: "none",
            created: "NA",
            episode: ["",""]
        ))
    )
}
