//
//  ImageTableViewCell.swift
//  PhotoSearch
//
//  Created by דוד נוי on 14/10/2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var photoName: UILabel!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    func showImage(url: URL?) {
        
        guard let imageUrl = url else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, err) in
            
            guard let data = data, err == nil else { return }
            
            DispatchQueue.main.async {
                self?.imageOutlet.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
}
