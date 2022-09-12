//
//  PhotoEventView.swift
//  PhotoApp
//
//  Created by Sophia Pramstrahler on 11.09.22.
//

import Foundation
import SwiftUI

struct PhotoEventView: View {
    var event: Event
    
    
    
    var body: some View {
        
        ScrollView {
            ForEach(event.imageArray, id: \.self) { image in
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .frame(width: 350, height: 350)
            }
            
        }
        
    }
}
