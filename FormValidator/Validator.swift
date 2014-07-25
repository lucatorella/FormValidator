//
//  Validator.swift
//  FormValidator
//
//  Created by Luca Torella on 22/07/2014.
//  Copyright (c) 2014 Luca Torella. All rights reserved.
//

import Foundation

enum Result {
    // when there will be something like NS_OPTIONS we won't need a list here
    case Error([ValidationError])
    case Success
}

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
    func validate() -> Result
}

class PasswordValidator : Validator {

    var password: String

    init() {
        password = ""
    }

    init(password: String) {
        self.password = password
    }

    func validate() -> Result {

        if countElements(password) < 4 || countElements(password) > 30 {
            return .Error([.ValidationErrorPassword])
        } else {
            return .Success
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

    func validate() -> Result {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if emailTest.evaluateWithObject(email) {
            return .Success
        } else {
            return .Error([.ValidationErrorEmail])
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
    
    func validate() -> Result {
        var ls: [ValidationError] = []
        var res: Result
        var b = false
        res = emailValidator.validate()
        switch res {
        case let .Error(err):
            ls = err
        default:
            b = true
        }

        res = passwordValidator.validate()
        switch res {
        case let .Error(err):
            ls += err
        default:
            b &= true
        }

        if b {
            return .Success
        } else {
            return .Error(ls)
        }
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

    func validate() -> Result {
        var ls: [ValidationError] = []
        var res: Result
        var b = false
        res = emailValidator.validate()
        switch res {
        case let .Error(err):
            ls = err
        default:
            b = true
        }

        res = passwordValidator.validate()
        switch res {
        case let .Error(err):
            ls += err
        default:
            b &= true
        }

        if passwordValidator.password != passwordConfirmationValidator.password {
            ls += .ValidationErrorPasswordConfirmation
        }

        if b {
            return .Success
        } else {
            return .Error(ls)
        }
    }
}


