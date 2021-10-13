//
//  ImageViewController.swift
//  PhotoSearch
//
//  Created by דוד נוי on 13/10/2021.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageOutlet: UIImageView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(urlString: urlString)
    }

    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        
        if let image = imageOutlet.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            saveAlert(didManageToSave: true)
        } else {
            saveAlert(didManageToSave: false)
        }
        
    }
    
    func configure(urlString: String?) {
           
        guard let str = urlString,
              let url = URL(string: str) else {
            return
        }
                
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            
            guard let data = data, err == nil else{
                return
            }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageOutlet.image = image
                }
            
        }.resume()
    }
    
    func saveAlert(didManageToSave: Bool){
        
        let title: String
        let massage: String
        
        if didManageToSave {
            title = "Saved"
            massage = "Managed to save"
        } else {
            title = "Error"
            massage = "Fild to save"
        }
        
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

