//
//  Validator.swift
//  FormValidator
//
//  Created by Luca Torella on 22/07/2014.
//  Copyright (c) 2014 Luca Torella. All rights reserved.
//

import Foundation

enum ValidationError {
    case ValidationErrorEmail, ValidationErrorPassword, ValidationErrorPasswordConfirmation

    func description() -> String {
        switch self {
        case .ValidationErrorEmail:
            return "email"
        case .ValidationErrorPassword:
            return "password"
        case .ValidationErrorPasswordConfirmation:
            return "confirmation email"
        }
    }
}

protocol Validator {
    func validate() -> (Bool, [ValidationError])
}

class PasswordValidator : Validator {

    var password: String

    init() {
        password = ""
    }

    init(password: String) {
        self.password = password
    }

    func validate() -> (Bool, [ValidationError]) {

        if countElements(password) < 4 || countElements(password) > 30 {
            return (false, [.ValidationErrorPassword])
        } else {
            return (true, [])
        }
    }
}

class EmailValidator : Validator {

    var email: String

    init() {
        email = ""
    }

    init(email: String) {
        self.email = email
    }

    func validate() -> (Bool, [ValidationError]) {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if emailTest.evaluateWithObject(email) {
            return (true, [])
        } else {
            return (false, [.ValidationErrorEmail])
        }
    }
}

class SignInValidator : Validator {

    let emailValidator = EmailValidator()
    let passwordValidator = PasswordValidator()

    init(email: String, password: String) {
        emailValidator.email = email
        passwordValidator.password = password
    }

    func validate() -> (Bool, [ValidationError]) {
        var (b1, err1) = emailValidator.validate()
        var (b2, err2) = passwordValidator.validate()
        return (b1 && b2, err1 + err2)
    }
}

class SignUpValidator : Validator {

    let emailValidator = EmailValidator()
    let passwordValidator = PasswordValidator()
    let passwordConfirmationValidator = PasswordValidator()

    init(email: String, password: String, passwordConfirmation: String) {
        emailValidator.email = email
        passwordValidator.password = password
        passwordConfirmationValidator.password = passwordConfirmation
    }

    func validate() -> (Bool, [ValidationError]) {
        var (b1, err1) = emailValidator.validate()
        var (b2, err2) = passwordValidator.validate()
        var b = b1 & b2
        var errs = err1 + err2

        if passwordValidator.password != passwordConfirmationValidator.password {
            errs.append(.ValidationErrorPasswordConfirmation)
            b = false
        }
        
        return (b, errs)
    }
}
