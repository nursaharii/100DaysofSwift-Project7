//
//  ViewController.swift
//  Project7
//
//  Created by Nurşah on 26.01.2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var lowerSearch = ""
    var filteredPetitions = [Petition]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "White House petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain,target: self,action: #selector(info))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        let urlString : String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        else {
            error()
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = filteredPetitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = petition.title//cell.textLabel?.text = ""
        content.secondaryText = petition.body//cell.detailTextLabel?.text = ""
        cell.contentConfiguration = content
        return cell
        
        // IOs 14 ile artık cell içerisindeki düzenlemeleri ContentConfiguration kullanarak yapıyoruz.
        //Eskiden cell.textLabel?.text = "" şeklinde title lable içeriği doluyordu. Xcode bunu kullanmamamız gerektiğini söyleyen bir uyarı veriyor.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            
            petitions = jsonPetitions.results
            submit()
            tableView.reloadData()
        }
    }
    func error() {
        let ac = UIAlertController(title: "Loading Error!", message: "Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func info() {
        let ac = UIAlertController(title: "Info", message: "This data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func search() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
                let submitAction = UIAlertAction (title: "Submit", style: .default) { [weak self, weak ac] action in
                    guard let search = ac?.textFields?[0].text else { return }
                    self?.lowerSearch = search.lowercased()
                    self?.submit()
                    self?.title = search + " in White House Petitions"
                    self?.tableView.reloadData()
                }
        let cancelAction = UIAlertAction (title: "Cancel", style: .default) { _ in
            self.lowerSearch = ""
            self.submit()
            self.title = "White House Petitions"
            self.tableView.reloadData()
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac,animated: true)
    }
    func submit() {
        if lowerSearch.isEmpty {
            filteredPetitions = petitions
            return
        }
        navigationItem.leftBarButtonItem?.title = "\(lowerSearch))"
        filteredPetitions = petitions.filter() { petition in
            if let _ = petition.title.lowercased().range(of: lowerSearch, options: .caseInsensitive) {
                return true
            }
            return false
        }
    }
}

