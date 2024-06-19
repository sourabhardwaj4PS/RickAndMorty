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
            
            TitleLabelView(title: "Name:", label: viewModel.name)
                .accessibilityIdentifier("name-\(viewModel.id)")
            
            TitleLabelView(title: "Gender:", label: viewModel.gender)
                .accessibilityIdentifier("gender-\(viewModel.id)")
            
            TitleLabelView(title: "Status:", label: viewModel.status)
                .accessibilityIdentifier("status-\(viewModel.id)")

            TitleLabelView(title: "Species:", label: viewModel.species)
                .accessibilityIdentifier("species-\(viewModel.id)")
            
            TitleLabelView(title: "No of episodes:", label: "\(viewModel.episodesCount)")
                .accessibilityIdentifier("episodes-\(viewModel.id)")
        })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("attributesView-\(viewModel.id)")
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
