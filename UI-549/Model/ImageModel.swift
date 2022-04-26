//
//  ImageModel.swift
//  UI-549
//
//  Created by nyannyan0328 on 2022/04/25.
//

import SwiftUI

struct ImageModel: Identifiable,Hashable,Codable {
    var id : String
    var download_url : String
    var author : String
    
    enum CordingKeys : String,CodingKey{
        
        case id
        case download_url
        case author
    }
}

enum ImageError : Error{
    
    case failed
}

