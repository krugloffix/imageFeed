import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileDescription: UILabel!
    
    @IBAction func logout(_ sender: Any) {
    }
}
