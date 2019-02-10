import Foundation

class CompanyService {

    static let main: CompanyService = {
        let service = CompanyService()
        service.load()
        return service
    }()

    private let companyDataAPI = CompanyAPI()
    private var company: Company!

    private var queryQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.dapulse.test.company_query"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    func load() {
        queryQueue.isSuspended = true
        companyDataAPI.fetch { [weak self] in
            self?.company = $0

            // start all queries
            self?.queryQueue.isSuspended = false
        }
    }

    func getCompanyName(_ completion: @escaping (String)->()) {
        queryQueue.addOperation {
            DispatchQueue.main.async {
                completion(self.company.name)
            }
        }
    }

    func getEmployees(forManagerId managerId: Int? = nil, completion: @escaping ([Employee])->()) {
        queryQueue.addOperation {
            let employees = self.company.employees.filter { $0.managerId == managerId }

            DispatchQueue.main.async {
                completion(employees)
            }
        }
    }

    func getTopLevelEmployees(completion: @escaping ([Employee])->()) {
        getEmployees(forManagerId: nil, completion: completion)
    }
}
