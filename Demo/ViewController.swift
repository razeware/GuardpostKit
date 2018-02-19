/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import GuardpostKit


class ViewController: UIViewController {
  
  let guardpost = Guardpost(baseUrl: "https://guardpost.rwdev.io",
                            urlScheme: "com.razeware.guardpost-demo://",
                            ssoSecret: "ZnWgQARSbrynT82UFilO8TlwZIavmYeWaK94Cw3drckb8Ejh6Z4BDP5dejmADvSz")

  @IBOutlet weak var errorLabel: UILabel!
  
  @IBAction func handleLoginTapped(_ sender: Any) {
    guardpost.login { (result) in
      switch result {
      case .failure(let error):
        self.displayError(error.localizedDescription)
      case .success(let user):
        self.displayError(.none)
        self.displayUser(user)
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let user = guardpost.currentUser {
      displayUser(user)
    }
  }
  
  private func displayError(_ error: String?) {
    DispatchQueue.main.async { [weak self] in
      if let error = error {
        self?.errorLabel.text = error
        self?.errorLabel.isHidden = false
      } else {
        self?.errorLabel.isHidden = true
      }
    }
  }
  
  private func displayUser(_ user: SingleSignOnUser) {
    let storyboard = UIStoryboard(name: "Main", bundle: .none)
    if let userVC = storyboard.instantiateViewController(withIdentifier: "userVC") as? UserTableViewController {
      userVC.user = user
      userVC.guardpost = guardpost
      
      self.present(userVC, animated: true, completion: .none)
    }
  }
  
}

