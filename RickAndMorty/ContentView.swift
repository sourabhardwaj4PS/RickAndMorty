//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import SwiftUI
import CharacterKit
import EpisodeKit

struct ContentView: View {
    var body: some View {
        TabView {
            CharactersHome(config: AppConfiguration())
                .tabItem {
                    Label("Characters", systemImage: "person.3.fill")
                }
            
            EpisodesView()
                .tabItem {
                    Label("Episodes", systemImage: "tv.fill")
                }
        }
        .tint(.green)
    }
}



#Preview {
    CharactersListView(viewModel: CharactersViewModelImpl())
}
