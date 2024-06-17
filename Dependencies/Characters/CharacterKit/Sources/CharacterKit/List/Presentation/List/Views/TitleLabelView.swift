//
//  TitleLabelView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI


struct TitleLabelView: View {
    
    var title: String
    var label: String
    
    init(title: String, label: String) {
        self.title = title
        self.label = label
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Text(label)
        }
    }
}
