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
                .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.name)-\(viewModel.id)")
            
            TitleLabelView(title: "Gender:", label: viewModel.gender)
                .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.gender)-\(viewModel.id)")
            
            TitleLabelView(title: "Status:", label: viewModel.status)
                .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.status)-\(viewModel.id)")

            TitleLabelView(title: "Species:", label: viewModel.species)
                .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.species)-\(viewModel.id)")
            
            TitleLabelView(title: "No of episodes:", label: "\(viewModel.episodesCount)")
                .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.episodes)-\(viewModel.id)")
        })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("\(CharacterConstants.AccessibilityIdentifiers.attributesViewPrefix)\(viewModel.id)")
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
