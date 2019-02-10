import SwiftyJSON

struct Company {
    var name: String
    var employees: [Employee]

    init(json: JSON) {
        self.name = json["company_name"].stringValue
        self.employees = json["employees"].arrayValue.map(Employee.init(json:))
    }
}
