//
//  UIAlertView+Extension.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/29.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "", handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
