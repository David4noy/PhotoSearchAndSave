//
//  ImageCollectionViewController.swift
//  PhotoSearch
//
//  Created by דוד נוי on 13/10/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionOutlet: UICollectionView!
    var results: [Results] = []
    var total_pages: Int = 1
    var pageNumber = 1
    var searchBar = UISearchBar()
    var ds = ImageDataSource()
    var textToSearch: String?
    var selectedUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        ds.delegate = self
        
        collectionOutlet.delegate = self
        collectionOutlet.dataSource = self
        collectionOutlet.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    @IBAction func nextPageBtn(_ sender: UIBarButtonItem) {
        
        if let text = textToSearch {
            if pageNumber < total_pages {
                pageNumber += 1
                ds.fetchPhotos(query: text, pageNumber: pageNumber)
            }
        }
    }
    
    @IBAction func prevPageBtn(_ sender: UIBarButtonItem) {
        if let text = textToSearch {
        if pageNumber > 1 {
            pageNumber -= 1
            ds.fetchPhotos(query: text, pageNumber: pageNumber)
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let dest = segue.destination as? ImageViewController {
            dest.urlString = selectedUrlString
        }
    }
    
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of items
       return results.count
   }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let fetchedImage = results[indexPath.row].urls.regular
       
       let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       guard let cell = defaultCell as? ImageCollectionViewCell else {
           return defaultCell }
   
       cell.configure(urlString: fetchedImage)

       return cell
   }
    
}

extension ImageCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedUrlString = results[indexPath.row].urls.regular
        performSegue(withIdentifier: "toImageViewController", sender: .none)
    }
    
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionOutlet.frame.size.width / 2, height: collectionOutlet.frame.size.width / 2)
    }
    
}

extension ImageCollectionViewController: ImageDataSourceDelegate {
    func onImageSearchResponse(results: [Results], total_pages: Int) {
        self.results = results
        self.total_pages = total_pages
        collectionOutlet.reloadData()
    }
    

}

extension ImageCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if let text = searchBar.text {
            print(text)
            results = []
            textToSearch = text
            ds.fetchPhotos(query: text, pageNumber: pageNumber)
        }
    }
    
    
}
