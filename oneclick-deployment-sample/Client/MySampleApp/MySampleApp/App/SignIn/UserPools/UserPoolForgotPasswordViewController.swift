//
//  UserPoolForgotPasswordViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.16
//
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider
import AWSMobileHubHelper
import AWSCognitoUserPoolsSignIn

class UserPoolForgotPasswordViewController: UIViewController {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    var userNameRow: FormTableCell?
    var tableDelegate: FormTableDelegate?
    
    @IBOutlet weak var tableFormView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onForgotPassword(_ sender: AnyObject) {
        guard let username = self.tableDelegate?.getValue(tableView, for: userNameRow!), !username.isEmpty else {
            
            let alert = UIAlertController(title: "Missing UserName",
                                          message: "Please enter a valid user name.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion:nil)

            return
        }
        
        self.user = self.pool?.getUser(username)
        self.user?.forgotPassword().continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else {return nil}
            DispatchQueue.main.async(execute: {
                if let error = task.error {
                    let nserror = error as NSError
                    let alert = UIAlertController(title: nserror.userInfo["__type"] as? String,
                                                  message:nserror.userInfo["message"] as? String,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion:nil)
                } else {
                    strongSelf.performSegue(withIdentifier: "NewPasswordSegue", sender: sender)
                }
            })
            return nil
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.pool = AWSCognitoIdentityUserPool.default()
    }
    
    func setUp() {
        userNameRow = FormTableCell(placeHolder: "User Name", type: InputType.text)
        tableDelegate = FormTableDelegate()
        tableDelegate?.add(cell: userNameRow!)
        tableView?.delegate = tableDelegate
        tableView?.dataSource = tableDelegate
        tableView.reloadData()
        UserPoolsUIHelper.setUpFormShadow(view: tableFormView)
        
        self.setUpBackground()
    }
    
    func setUpBackground() {
        self.view.backgroundColor = UIColor.white
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.tableFormView.center.y))
        backgroundImageView.backgroundColor = backgroundImageColor
        backgroundImageView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.title = "Forgot Password"
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPasswordViewController = segue.destination as? UserPoolNewPasswordViewController {
            newPasswordViewController.user = self.user
        }
    }
}
