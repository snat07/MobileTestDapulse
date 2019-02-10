//
//  HierarchyCollectionViewController.swift
//  MobileTest
//
//  Created by Sebastian Natalevich on 11/5/17.
//  Copyright © 2017 dapulse. All rights reserved.
//

import UIKit

private let employeeCellReuseIdentifier = "EmployeeCell"
private let hierarchyViewControllerId = "hierarchyViewController"
private let detailSegueId = "detailId"



class HierarchyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var hierarchyCollectionView: UICollectionView!
    
    @IBOutlet weak var managerDepartment: UILabel!
    @IBOutlet weak var managerName: UILabel!
    @IBOutlet weak var managerPosition: UILabel!

    @IBOutlet weak var managerProfilePicture: UIImageView!
    
    var employees: [Employee] = []
    var managerEmployee: Employee!
    
    let companyService = CompanyService.main
    
    override func viewDidLoad() {
        super.viewDidLoad()

        companyService.getEmployees(forManagerId: self.managerEmployee?.id, completion: { (employees) in
            self.employees = employees
            self.hierarchyCollectionView?.reloadData()
        })
        
        if !self.managerEmployee.profilePic.isEmpty {
            self.managerProfilePicture.sd_setImage(with: URL(string: self.managerEmployee.profilePic), completed: {
                (image, error, cacheType, url) in
                let circleImage = image?.circle
                self.managerProfilePicture.image = circleImage
                self.managerProfilePicture.border()
            })
        }
        else {
            self.managerProfilePicture.image = UIImage(named: "placeHolder")
            self.managerProfilePicture.border()
        }
        self.managerName.text = self.managerEmployee.name
        self.managerPosition.text = self.managerEmployee.title
        self.managerDepartment.text = self.managerEmployee.department
    }
    
    func initWithEmployee(employee: Employee) {
        self.managerEmployee = employee
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.employees.count
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: employeeCellReuseIdentifier, for: indexPath as IndexPath) as! EmployeeCell
    
        cell.initWithEmployee(employee: self.employees[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let employee: Employee = self.employees[indexPath.row]
        if employee.isManager {
        
            let hierarchyViewController: HierarchyViewController = self.storyboard?.instantiateViewController(withIdentifier: hierarchyViewControllerId) as! HierarchyViewController
            hierarchyViewController.initWithEmployee(employee: self.employees[indexPath.row])
            self.navigationController?.pushViewController(hierarchyViewController, animated: true)
            let backItem = UIBarButtonItem()
            backItem.title = self.managerDepartment.text
            navigationItem.backBarButtonItem = backItem
        }
        else {
            self.performSegue(withIdentifier: detailSegueId, sender: self.hierarchyCollectionView)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId {
            
            let nextScene = segue.destination as? DetailsViewController
            if sender is UICollectionView {
                let indexPath: NSIndexPath = self.hierarchyCollectionView.indexPathsForSelectedItems!.first! as NSIndexPath
                nextScene?.initWithEmployee(employee: self.employees[indexPath.row])
            }
            else {
                nextScene?.initWithEmployee(employee: self.managerEmployee)
            }
            let backItem = UIBarButtonItem()
            backItem.title = self.managerDepartment.text
            navigationItem.backBarButtonItem = backItem

            
        }

    }


}
