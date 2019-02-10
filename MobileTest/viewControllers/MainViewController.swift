
import UIKit
import SDWebImage

private let employeeCellReuseIdentifier = "EmployeeCell"
private let hierarchySegueId = "hierarchyId"


class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var employeesCollectionView: UICollectionView!
    var employees: [Employee] = []
    
    let companyService = CompanyService.main
    
    override func viewDidLoad() {
        super.viewDidLoad()

        companyService.getCompanyName({ (name) in
            self.companyNameLabel.text = name
        })

        companyService.getTopLevelEmployees(completion: { (employees) in
            self.employees = employees
            self.employeesCollectionView.reloadData()
        })
        
    }

    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.employees.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: employeeCellReuseIdentifier, for: indexPath as IndexPath) as! EmployeeCell
        
        cell.initWithEmployee(employee: self.employees[indexPath.row])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == hierarchySegueId {
            let nextScene = segue.destination as? HierarchyViewController
            let indexPath: NSIndexPath = self.employeesCollectionView.indexPathsForSelectedItems!.first! as NSIndexPath
            
            nextScene?.initWithEmployee(employee: employees[indexPath.row])
            let backItem = UIBarButtonItem()
            backItem.title = self.companyNameLabel.text
            navigationItem.backBarButtonItem = backItem

        }
    }
}

