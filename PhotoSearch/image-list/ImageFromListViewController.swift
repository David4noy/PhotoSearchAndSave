//
//  ImageFromListViewController.swift
//  PhotoSearch
//
//  Created by דוד נוי on 14/10/2021.
//

import UIKit

class ImageFromListViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showImage()
    }

    func showImage() {
        
        guard let imageUrl = url else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, err) in
            
            guard let data = data, err == nil else { return }
            
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
}
