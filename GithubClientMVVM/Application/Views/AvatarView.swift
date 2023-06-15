//
//  AvatarView.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/13.
//

import UIKit

final class AvatarView: UIView {
    var avatarUrl: URL? {
        didSet {
            if avatarUrl != nil {
                button.setImage(url: avatarUrl!, for: .normal)
            }
        }
    }
    
    var tapAction: () -> Void = {}
    private let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(button)
        button.frame = frame
        button.layer.masksToBounds = true
        button.layer.cornerRadius = frame.width / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    @objc func buttonDidTap() {
        tapAction()
    }
}


