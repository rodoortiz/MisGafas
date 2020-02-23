//
//  SnapshotViewController.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 21/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.

import UIKit


class SnapshotViewController: UIViewController {
    
    var photo: UIImage?
    
    @IBAction func didTapSavePhoto(_ sender: Any) {
        guard let image = snapshotView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) //Save photo in photo library
    }
    
    @IBOutlet weak var snapshotView: UIImageView!
    
    override func viewDidLoad() {
        snapshotView.image = photo //Takes photo to UIImageView 
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your photo has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } //Alerts when saving photo
    }
    
    
}
