import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "virus-background")!)
    }
    
    //WHO link
    @IBAction func whoBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string:"http://www.euro.who.int/en/home")! as URL, options: [:], completionHandler: nil)
    }
    
    //DHM link
    @IBAction func dkMinistryBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.sst.dk/en/english")! as URL, options: [:], completionHandler: nil)
    }
    
    //ECDC link
    @IBAction func ecdcBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.ecdc.europa.eu/en")! as URL, options: [:], completionHandler: nil)
    }
    
    //CDC link
    @IBAction func cdcBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.cdc.gov/")! as URL, options: [:], completionHandler: nil)
    }
    
    

}
