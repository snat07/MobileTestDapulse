//
//  DetailsViewController.swift
//  MobileTest
//
//  Created by Sebastian Natalevich on 12/5/17.
//  Copyright © 2017 dapulse. All rights reserved.
//

import UIKit
import MessageUI

class DetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var phoneValue: UILabel!
    @IBOutlet weak var emailValue: UILabel!
    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !self.employee.profilePic.isEmpty {
            self.profilePicture.sd_setImage(with: URL(string: self.employee.profilePic), completed: {
                (image, error, cacheType, url) in
                let circleImage = image?.circle
                self.profilePicture.image = circleImage
                self.profilePicture.border()
            })
        }
        else {
            self.profilePicture.image = UIImage(named: "placeHolder")
            self.profilePicture.border()
        }
        
        self.name.text        = self.employee.name
        self.position.text    = self.employee.title
        self.phoneValue.text  = self.employee.phone
        self.emailValue.text  = self.employee.email

    }
    
    func initWithEmployee(employee: Employee) {
        self.employee = employee
    }
    
    @IBAction func phoneTapped(_ sender: Any) {
        guard let number = URL(string: "telprompt://" + self.phoneValue.text!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } 
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([self.emailValue.text!])
        mailComposerVC.setSubject("Email Subject")
        mailComposerVC.setMessageBody("Email Body", isHTML: false)
        
        return mailComposerVC
    }
    

    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


}
