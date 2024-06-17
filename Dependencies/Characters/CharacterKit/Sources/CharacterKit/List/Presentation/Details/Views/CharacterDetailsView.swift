//
//  CharacterDetailsView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import SwiftUI

struct CharacterDetailsView<T>: View where T: CharacterViewModel {
    
    @State var viewModel: T
    
    public init(viewModel: @autoclosure @escaping () -> T) {
        _viewModel = State(wrappedValue: viewModel())
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ImageView(imageUrlString: viewModel.character.image)
                    .frame(maxWidth: .infinity, maxHeight: 360)
                    .background(Color.yellow)
                    .cornerRadius(5)
                
                Text(viewModel.character.name)
                    .font(.largeTitle)
                
                TitleLabelView(title: "Species:", label: viewModel.character.species)
                
                TitleLabelView(title: "Status:", label: viewModel.character.status)
                
                TitleLabelView(title: "Gender:", label: viewModel.character.gender)
                
                TitleLabelView(title: "Birth:", label: viewModel.character.created)

                Text("Episodes Aired:")
                    .font(.headline)
                
                ForEach(viewModel.character.episode.indices, id: \.self) { index in
                    let episode = viewModel.character.episode[index]
                    Text(episode)
                }
            }
        }
        .padding(8)
        .accessibility(identifier: "characterDetailView")
    }
}



#Preview {
    CharacterDetailsView(viewModel: CharacterViewModelImpl(
        character: CharacterImpl(
            id: 1,
            name: "Citadel of Ricks",
            status: "Alive",
            species: "Cartoon",
            type: "",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            url: "https://rickandmortyapi.com/api/character/2",
            created: "2017-11-04T18:50:21.651Z",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
                "https://rickandmortyapi.com/api/episode/3",
                "https://rickandmortyapi.com/api/episode/4",
                "https://rickandmortyapi.com/api/episode/5",
                "https://rickandmortyapi.com/api/episode/6",
                "https://rickandmortyapi.com/api/episode/7",
                "https://rickandmortyapi.com/api/episode/8",
                "https://rickandmortyapi.com/api/episode/9",
                "https://rickandmortyapi.com/api/episode/10",
                "https://rickandmortyapi.com/api/episode/11",
                "https://rickandmortyapi.com/api/episode/12",
                "https://rickandmortyapi.com/api/episode/13",
                "https://rickandmortyapi.com/api/episode/14",
                "https://rickandmortyapi.com/api/episode/15",
                "https://rickandmortyapi.com/api/episode/16",
                "https://rickandmortyapi.com/api/episode/17",
                "https://rickandmortyapi.com/api/episode/18",
                "https://rickandmortyapi.com/api/episode/19",
            ]
        )
    ))
}
