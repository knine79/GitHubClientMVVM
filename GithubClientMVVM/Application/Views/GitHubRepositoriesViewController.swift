//
//  GitHubRepositoriesViewController.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/09.
//

import UIKit
import RxSwift

class GitHubRepositoriesViewController: UIViewController, RouterProtocol {

    private var viewModel: GitHubRepositoriesViewModel
    
    private let avatarView = AvatarView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    private let tableView = UITableView()
    private let emptyView = UILabel()
    
    private let disposeBag = DisposeBag()
    
    private var gitHubRepositories: [GitHubRepositoryItem] = []
    
    init(viewModel: GitHubRepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupLayout()
        setupViews()
        bindData()
        bindTrigger()
    }
    
    private func setupLayout() {
        [tableView]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        view.addSubview(tableView)
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].activate()
        tableView.backgroundView = emptyView
    }
    
    private func setupViews() {
        title = "Repositories"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [.fixedSpace(16), UIBarButtonItem(customView: avatarView)]
        avatarView.tapAction = { [weak self] in
            self?.viewModel.avatarButtonDidTap()
        }
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GitHubRepositoryItemCell.self, forCellReuseIdentifier: "GitHubRepositoryItemCell")
        emptyView.text = "\(viewModel.username)에게는 public 레파지토리가 없습니다."
        emptyView.textAlignment = .center
        emptyView.isHidden = true
    }
    
    private func bindData() {
        Task {
            avatarView.avatarUrl = await viewModel.avatarUrl
        }
        viewModel.gitHubRepositories
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.emptyView.isHidden = !$0.isEmpty
                self?.gitHubRepositories = $0
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTrigger() {
        viewModel.route
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.route(to: $0)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        viewModel.viewDidAppear()
    }
    
}

extension GitHubRepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gitHubRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubRepositoryItemCell", for: indexPath) as? GitHubRepositoryItemCell else {
            return UITableViewCell()
        }
        cell.configure(item: gitHubRepositories[indexPath.row])
        return cell
    }
}

extension GitHubRepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
//        gitHubRepositories[indexPath.row].htmlUrl
    }
}
