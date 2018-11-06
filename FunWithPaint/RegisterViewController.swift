//
//  RegisterViewController.swift
//  FunWithPaint
//
//  Created by Avra Ghosh on 2/05/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource	 {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedField = 0
    var data = [User]()
    
    // Creating Occupation List
    let OccupationList =     [ "Doctor","Software Engineer","Lawyer","Dentist","Musician","Professor","Artist","Construction Engineer","Journalist","Police"]
    var OccupationMenu     = UIPickerView()
    
    // Creating Gender List
    let GenderList = 	[ "Male","Female"]
    var GenderMenu 	= UIPickerView()
    
    //Creating Age List
    let AgeList = ["10-18","19-29","30-45","45-55","56 above"]
    var AgeMenu = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the Picker View List for Occupation, Gender and Age
        OccupationMenu.dataSource = self
        OccupationMenu.delegate = self
        OccupationMenu.backgroundColor = UIColor.gray
        occupation.inputView = OccupationMenu
        occupation.placeholder = "Select Occupation"
        
        GenderMenu.dataSource = self
        GenderMenu.delegate = self
        GenderMenu.backgroundColor = UIColor.gray
        gender.inputView = GenderMenu
        gender.placeholder = "Select Gender"
        
        AgeMenu.dataSource = self
        AgeMenu.delegate = self
        AgeMenu.backgroundColor = UIColor.gray
        age.inputView = AgeMenu
        age.placeholder = "Select Age"

        // Do any additional setup after loading the view.
    }

    
    @IBAction func OccupationSelect(_ sender: UITextField) {
        let field = sender as UITextField
        selectedField = field.tag
    }
    
    @IBAction func GenderSelect(_ sender: UITextField) {
        let field = sender as UITextField
        selectedField = field.tag
    }
    
    @IBAction func AgeSelect(_ sender: UITextField) {
        let field = sender as UITextField
        selectedField = field.tag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BackButton(_ sender: UIButton) {
        let myAlert = UIAlertController(title: " ", message: "Do you want to leave the Registration Page", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true,completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            print("User wants to stay in Registration Page")
        }
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion:nil)
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        // Checking Text Field Tags, tag = 3 means Occupation is selected, tag = 4 is for Gender and tag = 5 for Age.
        if (selectedField == 3)
        {
            return OccupationList.count
        }
        if (selectedField == 4)
        {
            return GenderList.count
        }
        else
        {
            return AgeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (selectedField == 3)
        {
            return OccupationList[row]
        }
        else if (selectedField == 4)
        {
            return GenderList[row]
        }
        else
        {
            return AgeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (selectedField == 3)
        {
            occupation.text = OccupationList[row]
            occupation.resignFirstResponder()
        }
        else if (selectedField == 4)
        {
            gender.text = GenderList[row]
            gender.resignFirstResponder()
        }
        else
        {
            age.text = AgeList[row]
            age.resignFirstResponder()
        }        
    }
    
    @IBAction func Register(_ sender: UIButton) {
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
        
        //Check whether there is any empty field
        if ((self.username!.text?.isEmpty)! || (self.password!.text?.isEmpty)! || (self.occupation!.text?.isEmpty)! ||
            (self.gender!.text?.isEmpty)! || (self.age!.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "Empty Fields", message: "Please fill all the fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                print("Ok")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        
        //Password validation it must have atleast 6 characters, 1 uppercase,1 lower case alphabet and 1 special character
        if (passwordTest.evaluate(with: self.password!.text) == false) {
            
            let alert = UIAlertController(title: "Weak Password", message: "Your password is not strong, please make sure it has atleast 6 characters, upper and lower case alphabets and some special characters", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                print("You Pressed Ok")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        // Checkong whether the username used for registration is already in use or not.
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let predicate = NSPredicate(format: "username = %@", self.username!.text!)
        
        fetchrequest.predicate = predicate
        do
        {
            let result = try context.fetch(fetchrequest) as NSArray
            print(result.count)
            
              if result.count > 0
              {
                let myAlert = UIAlertController(title: "Account Exists", message: "Username already in use. Please try a different Username", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
                    print("Different username required")
                }
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion:nil)
              }
              else
              {
                 newUser.setValue(self.username!.text, forKey: "username")
                 newUser.setValue(self.password!.text, forKey: "password")
                 newUser.setValue(self.occupation!.text, forKey: "occupation")
                 newUser.setValue(self.gender!.text, forKey: "gender")
                 newUser.setValue(self.age!.text, forKey: "age")
              }
        }
        catch
        {
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
        }
        
        do {
            try context.save()
        }
        catch{
            print(error)
        }
        
        let myAlert = UIAlertController(title: "Successful", message: "Registration successful. Thank you!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true,completion: nil)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion:nil)
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
