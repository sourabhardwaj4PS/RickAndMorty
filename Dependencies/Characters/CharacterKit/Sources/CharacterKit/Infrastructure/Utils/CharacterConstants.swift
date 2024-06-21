//
//  CharacterConstants.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation

public enum CharacterConstants {
    
    public enum AccessibilityIdentifiers {
        // list view
        public static let listView = "charactersListView"
        public static let rowViewPrefix = "rowView-"
        public static let thumbnailViewPrefix = "thumbnailView-"
        public static let attributesViewPrefix = "attributesView-"
        
        // details view
        public static let detailsView = "characterDetailsView"
        public static let image = "image"
        public static let name = "name"
        public static let species = "species"
        public static let status = "status"
        public static let gender = "gender"
        public static let birth = "birth"
        public static let episodes = "episodes"
    }
    
    public enum Titles {
        
        public enum Page {
            public static let characters = "Characters"
            public static let characterDetails = "In depth"
        }
        
        public enum Alerts {
            public static let unexpected = "Unexpected!"
            public static let failure = "Opps!"
            public static let somethingWentWrong = "Something went wrong!"
        }
        
        public enum Buttons {
            public static let ok = "Ok"
            public static let retry = "Retry"
            public static let cancel = "Cancel"
        }
    }
}

enum AttributeLabels: String {
    case name = "Name"
    case gender = "Gender"
    case status = "Status"
    case species = "Species"
    case episodes = "No of episodes"
    case episodesAired = "Episodes Aired"
    case birth = "Birth"
}
