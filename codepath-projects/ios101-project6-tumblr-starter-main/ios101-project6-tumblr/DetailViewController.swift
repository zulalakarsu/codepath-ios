//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Zulal Akarsu on 09/04/2025.
//
import Nuke
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
        var post: Post!
       
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let photo = post.photos.first {
                let imageUrl = photo.originalSize.url
                Nuke.loadImage(with: imageUrl, into: backdropImageView)
            }

            captionTextView.text = post.caption.trimHTMLTags()
            navigationItem.largeTitleDisplayMode = .never

        }
    }
    
