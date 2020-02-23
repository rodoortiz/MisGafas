//
//  BuyViewController.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 22/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    
    var product: String?
    var contentTypeSelected: Content = .none
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func viewDidLoad() {
        switch contentTypeSelected{
        case .none: break
        case .model1:
            productName.text = "Model 1"
            productImage.image = UIImage(named: "Model1")
            priceLabel.text = "$399.00"
        case .model2:
            productName.text = "Model 2"
            productImage.image = UIImage(named: "Model2")
            priceLabel.text = "$349.00"
        case .model3:
            productName.text = "Model 3"
            productImage.image = UIImage(named: "Model3")
            priceLabel.text = "$429.00"
        }
    }
}
