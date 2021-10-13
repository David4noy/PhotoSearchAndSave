//
//  MainViewController.swift
//  PhotoSearch
//
//  Created by דוד נוי on 13/10/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageResultsViewOutlet: UIView!
    
    var results: [Results] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imageResultsViewOutlet.isHidden = false

    }


    


}

