//
//  APIResponse.swift
//  PhotoSearch
//
//  Created by דוד נוי on 13/10/2021.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Results]
}
