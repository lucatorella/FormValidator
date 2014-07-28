FormValidator
=============

A form validator in Swift.

### Getting started

A simple protocol...

```
protocol Validator {
	func validate() -> (Bool, [ValidationError])
}
```

...and a couple of classes to check a single field or an entire form. It's easy to add validators or to edit them.

A simple example:

```
let signInValidator = SignInValidator(email: emailField.text, password: passwordField.text)
signInValidator.validate()
```





