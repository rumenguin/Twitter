//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by RUMEN GUIN on 25/03/23.
//

import UIKit
import Combine
import SDWebImage

final class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
       
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0 //hidden
        return view
        
    }()
    
    private let profileTableView: UITableView = {
       
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never //ignore safe area
        navigationController?.navigationBar.isHidden = true
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveUser()
    }
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.usernameLabel.text  = "@\(user.username)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinedDateLabel.text = " Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "")"
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        
        let profileTableViewConstraints = [
        
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
        
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20) //for iPhone 13,14 height is 40, for iPhone 7,8 height is 20
            
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        //yPositon > 150 because (line 115 in ProfileTableViewHeader)
        //profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        
        // When scrolling.... (making navbar prominant)
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in
                
            }
        }
        // when not scrolling... (hiding nav bar)
        else if yPosition < 0 && !isStatusBarHidden {
            
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in
                
            }
        }
    }
}
