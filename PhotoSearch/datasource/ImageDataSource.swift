//
//  ImageDataSource.swift
//  PhotoSearch
//
//  Created by דוד נוי on 13/10/2021.
//

import Foundation

protocol ImageDataSourceDelegate {
    func onImageSearchResponse(results: [Results],total_pages: Int)
}

struct ImageDataSource {
    
    var delegate: ImageDataSourceDelegate?
    
    func fetchPhotos(query: String, pageNumber: Int = 1){
        
        let accessKey = "YTz7fZ8Qxx6rPBTCKkADzJ8NcetfzYZOekS_REIbeiQ"
        
        let urlString = "https://api.unsplash.com/search/photos?page=\(pageNumber)&per_page=30&query=\(query)&client_id=\(accessKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {  (data, response, err) in
            
            guard let data = data, err == nil else{
                print("error")
                return
            }
            
            do {
                let jsonResults = try JSONDecoder().decode(APIResponse.self, from: data)

                DispatchQueue.main.async {
                    delegate?.onImageSearchResponse(results: jsonResults.results, total_pages: jsonResults.total_pages)
                }
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    
}
