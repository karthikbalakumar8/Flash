//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        emailTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print("Error signing in with this email ID")
            } else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    


    
}  
