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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
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
                  self.tableView.reloadData()
              }
              print(searchResponse)
              
          } catch {
              
          }
      }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultsTableViewCell
        let item = results[indexPath.row]
        cell?.textFieldLabel.text = item.Text
        cell?.firstURLLabel.text = item.FirstURL
        return cell ?? UITableViewCell()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // dismiss the keyboard
        guard let query = searchBar.text, !query.isEmpty else { return }
        doApi(searchedText: query)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchBar.resignFirstResponder() // dismiss the keyboard
        guard let query = searchBar.text, !query.isEmpty else { return }
        doApi(searchedText: query)
    }
}
