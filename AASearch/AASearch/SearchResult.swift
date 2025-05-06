//
//  SearchResult.swift
//  AASearch
//
//  Created by Yassine Lamtalaa on 5/5/25.
//

import Foundation

struct SearchResponse: Decodable {
    let Results: [ResultItem]
}

struct ResultItem: Decodable {
    let FirstURL: String
    let Text: String
}
