//
//  NewsTableViewController.swift
//  PoliceApp
//
//  Created by Aziza Gilash on 29.03.2025.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    
    let newsApi = "https://newsapi.org/v2/top-headlines?country=us&apiKey=00952b0b990f4535b22cbb34426be3fd"
    
    
    var articles: [NewsArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews()
    }
    
    // Fetch news data
    func fetchNews() {
        guard let url = URL(string: newsApi) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                self.articles = newsResponse.articles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        let article = articles[indexPath.row]
        cell.newsTitle.text = article.title
        cell.newsDescription.text = article.description ?? "No description available"
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.newsImage.image = UIImage(data: data)
                    }
                }
            }
        } else {
            cell.newsImage.image = UIImage(named: "placeholder") // Provide a default image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
}
