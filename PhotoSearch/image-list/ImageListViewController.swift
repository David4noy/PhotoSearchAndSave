//
//  ImageListViewController.swift
//  PhotoSearch
//
//  Created by דוד נוי on 14/10/2021.
//

import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet weak var imageListTableView: UITableView!
    var photosUrls: [URL] = []
    var photosFolderUrl: URL?
    var imageUrlForShoe: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageListTableView.delegate = self
        imageListTableView.dataSource = self

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllPhotos()
    }
    
    func getAllPhotos() {
        
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let photosUrl = url.appendingPathComponent("Photos")
        
        do {
            try manager.createDirectory(at: photosUrl, withIntermediateDirectories: true, attributes: [:])
        } catch  {
            print(error)
        }
        photosFolderUrl = photosUrl
        
        guard let folderUrl = photosFolderUrl else {
            return
        }
        
        do {
            // Get the directory contents urls (including subfolders urls)
            photosUrls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil)
        //    print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            photosUrls = photosUrls.filter{ $0.pathExtension == "png" }
            
        } catch {
            print(error)
        }
        
        imageListTableView.reloadData()
    }

}

extension ImageListViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ImageFromListViewController{
            dest.url = imageUrlForShoe
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imageUrlForShoe = photosUrls[indexPath.row]
        performSegue(withIdentifier: "showImageFromList", sender: .none)
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        
        
        let cell:UITableViewCell = imageListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          
        if let cell = cell as? ImageTableViewCell{
                        
            let urlFromList = photosUrls[indexPath.row]
            
            cell.photoName.text = urlFromList.deletingPathExtension().lastPathComponent
            cell.showImage(url: urlFromList)
        }
          return cell
    }
    
    
}

