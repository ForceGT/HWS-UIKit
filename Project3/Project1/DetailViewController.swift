//
//  DetailViewController.swift
//  Project1
//
//  Created by gtxtreme on 13/07/22.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var image: String?
    var imageCount: Int?
    var imageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image \(imageIndex ?? 0) of \(imageCount ?? 0)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = image {
            imageView.image = UIImage(named:imageToLoad)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    @objc func actionTapped(){
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
