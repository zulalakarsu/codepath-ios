import UIKit
import Nuke

class ViewController: UIViewController {

    // Outlet for the table view (connect this in storyboard)
    @IBOutlet weak var tableView: UITableView!
    
    // Store the fetched posts here
    var posts: [Post] = []
    
    let refreshControl = UIRefreshControl()

    var currentURLString = "https://api.tumblr.com/v2/blog/peacecorps.tumblr.com/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Configure refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Initial data fetch
        fetchPosts()
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        // When refreshed, change the URL to the humansofnewyork blog URL
        currentURLString = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"
        fetchPosts()
    }
    
    func fetchPosts() {
        guard let url = URL(string: currentURLString) else {
            print("❌ Invalid URL string: \(currentURLString)")
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                
                // Update posts on the main thread and reload table view
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.posts = blog.response.posts
                    print("✅ We got \(self.posts.count) posts!")
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        session.resume()
    }
}


// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    // Return number of rows in the table view based on the posts count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Dequeue and configure the cell for each post
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue our custom PostCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            fatalError("Could not dequeue PostCell")
        }
        
        let post = posts[indexPath.row]
        
        // Set the summary text
        cell.summaryLabel.text = post.summary
        
        // Load the image using Nuke (if available)
        if let photo = post.photos.first {
            Nuke.loadImage(with: photo.originalSize.url, into: cell.postImageView)
        } else {
            cell.postImageView.image = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate (Optional)

extension ViewController: UITableViewDelegate {
    // Implement delegate methods if needed (e.g., for row selection)
}
}
