//
//  EmployeeCell.swift
//  MobileTest
//
//  Created by Sebastian Natalevich on 11/5/17.
//  Copyright © 2017 dapulse. All rights reserved.
//

import UIKit

class EmployeeCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    
    func initWithEmployee(employee: Employee) {

        if !employee.profilePic.isEmpty {
            self.profilePicture.sd_setImage(with: URL(string: employee.profilePic), completed: {
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
       
        self.name.text = employee.name
        self.position.text = employee.title
    }
    

    

}
