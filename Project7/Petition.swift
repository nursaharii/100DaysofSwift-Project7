//
//  Petition.swift
//  Project7
//
//  Created by Nurşah on 26.01.2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions : Codable {
    var results : [Petition]
}


