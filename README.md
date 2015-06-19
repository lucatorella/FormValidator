FormValidator
=============

A form validator in Swift.

### Getting started

FormValidator is built around this simple protocol:

```
protocol Validator {
    func validate() -> Result<Void, [ValidationError]>
}
```
Every validator class should implement it, from the simple `PasswordValidator`, to a more complex `SignInValidator` or your custom form validator.
I've already introduced a couple of classes, that you can tweak based on your requirements, and you can build more on top of that.

A simple example:

```
SignInValidator(email: emailField.text, password: passwordField.text).validate()
```





