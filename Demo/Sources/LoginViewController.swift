// Copyright © 2018 Hootsuite.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License. All rights reserved.

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
