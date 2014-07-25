FormValidator
=============

A form validator in Swift.

### Getting started

A simple protocol

```
protocol Validator {
		func validate() -> Result
}```

and a couple of class to check a single field or a n entire form: `PasswordValidator`, `EmailValidator`, `SignInValidator`, `SignUpValidator`

A simple example:

```
let signInValidator = SignInValidator(email: emailField.text, password: passwordField.text)
signInValidator.validate()
```



