//
//  ViewController.swift
//  AASearch
//
//  Created by Yassine Lamtalaa on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var results: [ResultItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        doApi(sarchedText: "Dallas, TX")
    }
    
    func doApi(sarchedText: String) {
        
    guard let url = URL(string: "https://api.duckduckgo.com/?q=American+Airlines&format=json&pretty=1") else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
          guard let data = data else { return }
          
          do {
              
              let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
              
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
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        doApi(sarchedText: query)
    }
}
