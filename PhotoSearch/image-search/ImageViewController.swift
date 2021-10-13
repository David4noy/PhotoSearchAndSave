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
    var photosFolderUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let photosUrl = url.appendingPathComponent("Photos")
        
        do {
            try manager.createDirectory(at: photosUrl, withIntermediateDirectories: true, attributes: [:])
        } catch  {
            print(error)
        }
        
        photosFolderUrl = photosUrl
        
        configure(urlString: urlString)
        
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        addNameAlert()
    }
    
    func saveToDocument(fileName: String){
        
        guard let image = imageOutlet.image else { return }
        
        guard let fileURL = photosFolderUrl?.appendingPathComponent("\(fileName).png") else {return}
        
        if let data = image.pngData() {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                didSaveAlert(didManageToSave: true)
            } catch {
                didSaveAlert(didManageToSave: false)
            }
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
    
    func addNameAlert(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let fileDateStr = dateFormatter.string(from:Date())
        var fileName: String = "My Image \(fileDateStr)"
      //  fileName = fileName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        
        let alert = UIAlertController(title: "Choose A Name", message: "Default name is date and hour", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = fileName
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            if let name = alert.textFields?.first?.text {
                let check = name.filter { !$0.isWhitespace }
                if name.isEmpty || check.isEmpty || check == "" {
                    print("Empty")
                } else {
                    fileName = name
                  //  fileName = fileName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                }
            }
            
            self?.saveToDocument(fileName: fileName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func didSaveAlert(didManageToSave: Bool){
        
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

