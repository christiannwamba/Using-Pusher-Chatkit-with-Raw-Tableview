//
//  AuthViewController.swift
//  chatroom
//
//  Created by Neo Ighodaro on 27/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import Alamofire

class AuthViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        loginButton.addTarget(self, action:#selector(loginButtonWasPressed), for: .touchUpInside)
    }
    
    @objc func textDidChange(_ sender: Any?) -> Void {
        loginButton.isEnabled = textField.text!.characters.count >= 3
    }
    
    @objc func loginButtonWasPressed(_ sender: Any?) -> Void {
        textField.isEnabled = false
        loginButton.isEnabled = false
        
        login(username: textField.text!) { (response) in
            self.username = self.textField.text!
            self.performSegue(withIdentifier: "loadRoomsTableViewController", sender: self)
        }
    }
    
    private func login(username: String, completion: @escaping (_ response: Any?) -> Void) {
        let payload: Parameters = ["username": username]
        
        let request = Alamofire.request(AppConstants.ENDPOINT + "/login", method: .post, parameters: payload)
        
        request.validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion(response.data!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadRoomsTableViewController" {
            let ctrl = (segue.destination as! UINavigationController).viewControllers.first as! RoomsTableViewController
            ctrl.username = username
        }
    }
}
