//
//  CheckoutViewController.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 23/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
   
    @IBAction func didTapOrder(_ sender: Any) {
        let alertController = UIAlertController(title: "Successful order", message: "Your order has been made", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { (UIAlertAction) -> Void in
               self.dismiss(animated: true, completion: nil)
        })

        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }

}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
