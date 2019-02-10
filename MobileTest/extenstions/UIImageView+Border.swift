
import UIKit

extension UIImageView {
    func border() {
        self.layer.borderColor   = UIColor(red: 203/255, green: 130/255, blue: 20/255, alpha:1.0).cgColor
        self.layer.borderWidth   = 3.0
        self.layer.cornerRadius  = self.bounds.width/2
        self.layer.masksToBounds = true
    }
    


}
