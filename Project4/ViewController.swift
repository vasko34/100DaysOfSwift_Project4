import UIKit

class ViewController: UITableViewController {
    var websites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWebsitesURL = Bundle.main.url(forResource: "startWebsites", withExtension: "txt") {
            if let startWebsites = try? String(contentsOf: startWebsitesURL) {
                websites = startWebsites.components(separatedBy: "\n")
            }
        }
        if websites.isEmpty {
            websites[0] = "hackingwithswift.com"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

