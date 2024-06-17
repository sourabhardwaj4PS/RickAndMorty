//
//  MockData.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation
@testable import CharacterKit

extension CharacterImpl {
    
    static func mockedCharacter() -> CharacterImpl {
        return CharacterImpl(
            id: 1,
            name: "Citadel Ricks",
            status: "Alive",
            species: "Cartoon",
            type: "",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            url: "none",
            created: "NA",
            episode: ["episode 1","episode 2","episode 3"]
        )
    }
}

extension CharactersImpl {
    
    static func mockedCharacters() -> CharactersImpl {
        return CharactersImpl(info:
                                CharacterInfoImpl(count: 1, pages: 1, next: nil, prev: nil),
                              results: [
                                CharacterImpl.mockedCharacter(),
                                CharacterImpl.mockedCharacter()
                              ])
    }
}

public struct MockData {
    static let allCharacters = """
    {
        "info": {
            "count": 2,
            "pages": 1,
            "next": null,
            "prev": null
        },
        "results": [
            {
                "id": 1,
                "name": "Rick",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "gender": "Male",
                "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                "url": "",
                "created": "17-06-2024",
                "episode": []
            },
            {
                "id": 2,
                "name": "Morty Smith",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "gender": "Male",
                "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                "url": "",
                "created": "14-06-2024",
                "episode": []
            },
            {
                "id": 3,
                "name": "Justin",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "gender": "Male",
                "image": "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
                "url": "",
                "created": "14-06-2024",
                "episode": []
            },
            {
                "id": 4,
                "name": "Treudo",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "gender": "Male",
                "image": "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
                "url": "",
                "created": "14-06-2024",
                "episode": []
            }
        ]
    }
    """.data(using: .utf8)!
    
    static let character = """
    {
          "id": 2,
          "name": "Morty Smith",
          "status": "Alive",
          "species": "Human",
          "type": "",
          "gender": "Male",
          "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
          "episode": [
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
            "https://rickandmortyapi.com/api/episode/20",
            "https://rickandmortyapi.com/api/episode/21",
            "https://rickandmortyapi.com/api/episode/22",
            "https://rickandmortyapi.com/api/episode/23",
            "https://rickandmortyapi.com/api/episode/24",
            "https://rickandmortyapi.com/api/episode/25",
            "https://rickandmortyapi.com/api/episode/26",
            "https://rickandmortyapi.com/api/episode/27",
            "https://rickandmortyapi.com/api/episode/28",
            "https://rickandmortyapi.com/api/episode/29",
            "https://rickandmortyapi.com/api/episode/30",
            "https://rickandmortyapi.com/api/episode/31",
            "https://rickandmortyapi.com/api/episode/32",
            "https://rickandmortyapi.com/api/episode/33",
            "https://rickandmortyapi.com/api/episode/34",
            "https://rickandmortyapi.com/api/episode/35",
            "https://rickandmortyapi.com/api/episode/36",
            "https://rickandmortyapi.com/api/episode/37",
            "https://rickandmortyapi.com/api/episode/38",
            "https://rickandmortyapi.com/api/episode/39",
            "https://rickandmortyapi.com/api/episode/40",
            "https://rickandmortyapi.com/api/episode/41",
            "https://rickandmortyapi.com/api/episode/42",
            "https://rickandmortyapi.com/api/episode/43",
            "https://rickandmortyapi.com/api/episode/44",
            "https://rickandmortyapi.com/api/episode/45",
            "https://rickandmortyapi.com/api/episode/46",
            "https://rickandmortyapi.com/api/episode/47",
            "https://rickandmortyapi.com/api/episode/48",
            "https://rickandmortyapi.com/api/episode/49",
            "https://rickandmortyapi.com/api/episode/50",
            "https://rickandmortyapi.com/api/episode/51"
          ],
          "url": "https://rickandmortyapi.com/api/character/2",
          "created": "2017-11-04T18:50:21.651Z"
        }
    """.data(using: .utf8)!
}
