//
//  ViewController.swift
//  FormValidator
//
//  Created by Luca Torella on 22/07/2014.
//  Copyright (c) 2014 Luca Torella. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func submit(sender: AnyObject) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        let sv = SignInValidator(email: emailField.text!, password: passwordField.text!)

        var title = ""
        switch sv.validate() {
        case .Success():
            title = "All fields looks good!"
        case .Failure(let errors):
            title = "There are issues with the following field(s): "
            let c = errors.count
            var i = 0
            for err in errors {
                title += err.description()
                if i++ != c-1 {
                    title += ", "
                }
            }
        }

        let a = UIAlertView()
        a.message = title
        a.addButtonWithTitle("ok")
        a.show()
    }
}

