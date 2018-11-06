//
//  LoginViewController.swift
//  FunWithPaint
//
//  Created by Avra Ghosh on 6/05/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do
        {
            // Setting up a guest account with Username Admin which can be accessed by anyone who doesn't want to register themselves
            let result = try context.fetch(fetchrequest) as NSArray
            let firstUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
            if result.count == 0
            {
                firstUser.setValue("Admin", forKey: "username")
                firstUser.setValue("Password1@", forKey: "password")
                firstUser.setValue("Software Engineer", forKey: "occupation")
                firstUser.setValue("Male", forKey: "gender")
                firstUser.setValue("19-29", forKey: "age")
            }
            do {
                try context.save()
            }
            catch{
                print(error)
            }
        }
        catch
        {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginCheck(_ sender: UIButton) {
        let userName = uname.text
        let password = pass.text
        // Checking for empty fields
        if (userName == " " || password == " ")
        {
            let alert = UIAlertController(title: "Information", message: "Please enter all the fields", preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
       }
       else
       {
        self.CheckForUserNameAndPasswordMatch(username : userName!, password : password!)
       }
    }
    
    func CheckForUserNameAndPasswordMatch( username: String, password : String)
    {
        // Based on the username and password entered by the user in the corresponding text fields the login authentication is performed. If the username and password is registered the login access is granted to user else an alert pops up with message Invalid Login.
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let context = app.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let predicate = NSPredicate(format: "username = %@", username)
        
        fetchrequest.predicate = predicate
        do
        {
            let result = try context.fetch(fetchrequest) as NSArray
            
            if result.count == 0
            {
                let alert = UIAlertController(title: "Invalid Login", message: "Username not found!!!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            if result.count>0
            {
                let objectentity = result.firstObject as! User
                
                if objectentity.username == username && objectentity.password == password
                {
                    print("Login Succesfully")
                    
                    self.performSegue(withIdentifier: "DrawView", sender: self)
                }
                else
                {
                    
                    let alert = UIAlertController(title: "Invalid Login", message: "Wrong username or password !!!", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
            
        catch
        {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
