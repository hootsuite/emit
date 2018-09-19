//  Copyright © 2018 Hootsuite. All rights reserved.

import Foundation
import Emit

protocol LoginFlowViewModel {
    var loginCredentialsValid: ObservableVariable<Bool> { get }
    var email: ObservableVariable<String> { get }
    var password: ObservableVariable<String> { get }
    var alertToDisplay: Signal<UIAlertController?> { get }

    func login()
}

final class LoginViewModel: LoginFlowViewModel {
    private struct Regex {
        static let password = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }

    let loginCredentialsValid: ObservableVariable<Bool> = ObservableVariable(false)
    let email: ObservableVariable<String> = ObservableVariable("")
    let password: ObservableVariable<String> = ObservableVariable("")

    let alertToDisplay: Signal<UIAlertController?> = Signal()

    private var errorAlert: UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Login failed. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }

    private var successAlert: UIAlertController {
        let alert = UIAlertController(title: "Success", message: "You are now logged in!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }

    init() {
        email.signal.subscribe(owner: self) { [weak self] _ in
            self?.validInput()
        }

        password.signal.subscribe(owner: self) { [weak self] _ in
            self?.validInput()
        }
    }

    func login() {
        let isSuccess = arc4random_uniform(2) == 0
        if isSuccess {
            alertToDisplay.emit(successAlert)
        } else {
            alertToDisplay.emit(errorAlert)
        }
    }

    private func validInput() {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.email)
        let isEmailValid = emailPredicate.evaluate(with: email.value)

        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.password)
        let isPasswordValid = passwordPredicate.evaluate(with: password.value)

        loginCredentialsValid.value = isEmailValid && isPasswordValid
    }
}
