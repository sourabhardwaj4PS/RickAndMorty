//
//  MockData.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation

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
            "https://rickandmortyapi.com/api/episode/16"
          ],
          "url": "https://rickandmortyapi.com/api/character/2",
          "created": "2017-11-04T18:50:21.651Z"
        }
    """.data(using: .utf8)!
    
    static let someData = """
    {
        "someKey": "someValue"
    }
    """.data(using: .utf8)!
}
