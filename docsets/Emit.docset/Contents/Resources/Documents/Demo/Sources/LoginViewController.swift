// Copyright © 2017 Hootsuite. All rights reserved.

import Foundation
import UIKit
import Emit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginFlowViewModel? {
        didSet {
            setupSignals()
        }
    }

    private func setupSignals() {
        viewModel?.loginCredentialsValid.signal.subscribe(owner: self) { [weak self] isValid in
            self?.loginButton.isEnabled = isValid
        }

        viewModel?.alertToDisplay.subscribe(owner: self, action: { [weak self] alert in
            guard let alert = alert else {
                return
            }
            self?.present(alert, animated: true, completion: nil)
        })
    }

    @IBAction func loginButtonSelected(_ sender: Any) {
       viewModel?.login()
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel?.email.value = emailTextField.text ?? ""
        } else {
            viewModel?.password.value = passwordTextField.text ?? ""
        }
    }

}
