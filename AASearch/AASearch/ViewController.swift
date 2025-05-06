//
//  ViewController.swift
//  AASearch
//
//  Created by Yassine Lamtalaa on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var results: [ResultItem] = []
    var relatedTopics: [RelatedTopicItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        tableView.backgroundColor = UIColor.systemGray5
        
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.backgroundColor = .white
        
        tableView.sectionHeaderTopPadding = 0
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.leftView = nil  // removes the search icon
        }

        doApi(searchedText: searchBar.text ?? "")
    }

    func doApi(searchedText: String) {
        let encoded = searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.duckduckgo.com/?q=\(encoded)&format=json&pretty=1") else {
            return
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }

            do {
                let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.results = searchResponse.Results
                    self.relatedTopics = searchResponse.RelatedTopics
                    self.tableView.reloadData()
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "RESULTS" : "RELATED TOPICS"
    }
    
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = UIColor.systemGray5
            header.textLabel?.textColor = .systemGray2
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }

    // ✅ MARK: Row counts per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? results.count : relatedTopics.count
    }

    // ✅ MARK: Cell content for both sections
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultsTableViewCell

        if indexPath.section == 0 {
            let item = results[indexPath.row]
            cell?.textFieldLabel.text = item.Text
            cell?.firstURLLabel.text = item.FirstURL
        } else {
            let topic = relatedTopics[indexPath.row]
            cell?.textFieldLabel.text = topic.Text
            cell?.firstURLLabel.text = topic.FirstURL
        }

        cell?.firstURLLabel.textColor = .gray
        cell?.firstURLLabel.font = UIFont.systemFont(ofSize: 13)

        return cell ?? UITableViewCell()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        doApi(searchedText: query)
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        doApi(searchedText: query)
    }
}
