//
//  APIModels.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation

// MARK: - Image Upload Response
struct ImageUploadResponse: Codable {
    let status: Bool
    let data: ImageUploadData?
}

struct ImageUploadData: Codable {
    let id: String
}

// MARK: - Result Response
struct ResultResponse: Codable {
    let status: Bool
    let data: [String]? // array of image URLs, or nil while processing
}

// MARK: - Local wrapper for the UI
struct ResultData {
    let id: String
    let imageURLs: [String]
    var bestImageURL: String? { imageURLs.first }
}
