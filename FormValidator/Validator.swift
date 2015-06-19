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
    func validate() -> Result<Void, [ValidationError]>
}

class PasswordValidator : Validator {

    var password: String

    init() {
        password = ""
    }

    init(password: String) {
        self.password = password
    }

    func validate() -> Result<Void, [ValidationError]> {
        if password.characters.count < 4 || password.characters.count > 30 {
            return Result.Failure([.ValidationErrorPassword])
        } else {
            return Result.Success()
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

    func validate() -> Result<Void, [ValidationError]> {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if emailTest.evaluateWithObject(email) {
            return Result.Success()
        } else {
            return Result.Failure([.ValidationErrorEmail])
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

    func validate() -> Result<Void, [ValidationError]> {
        let result1 = emailValidator.validate()
        let result2 = passwordValidator.validate()
        switch (result1, result2) {
        case (.Success(), .Success()):
            return .Success()
        case (.Success(), .Failure(let error)):
            return .Failure(error)
        case (.Failure(let error), .Success()):
            return .Failure(error)
        case (.Failure(let error1), .Failure(let error2)):
            let error = error1 + error2
            return .Failure(error)
        }
    }
}

class SignUpValidator : Validator {

    let emailValidator = EmailValidator()
    let passwordValidator = PasswordValidator()
    let passwordConfirmation: String

    init(email: String, password: String, passwordConfirmation password2: String) {
        emailValidator.email = email
        passwordValidator.password = password
        passwordConfirmation = password2
    }

    func validate() -> Result<Void, [ValidationError]> {
        let result1 = emailValidator.validate()
        let result2 = passwordValidator.validate()
        let result3: Result<Void, [ValidationError]>
        if passwordValidator.password != passwordConfirmation {
            result3 = Result.Failure([.ValidationErrorPasswordConfirmation])
        } else {
            result3 = Result.Success()
        }
         return [result2, result3].reduce(result1) { (r1, r2) -> Result<Void, [ValidationError]> in
            switch (result1, result2) {
            case (.Success(), .Success()):
                return .Success()
            case (.Success(), .Failure(let error)):
                return .Failure(error)
            case (.Failure(let error), .Success()):
                return .Failure(error)
            case (.Failure(let error1), .Failure(let error2)):
                let error = error1 + error2
                return .Failure(error)
            }
        }
    }
}
