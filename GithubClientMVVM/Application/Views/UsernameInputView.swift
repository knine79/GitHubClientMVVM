//
//  UsernameInputView.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import Foundation
import SwiftUI
import RxSwift

struct UsernameInputView: View {
    @State var username: String = ""
    @State var editing: Bool = false
    
    private let viewModel: UsernameInputViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: UsernameInputViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("GitHub")
                .font(.system(.largeTitle, weight: .semibold))
            
            HStack {
                TextField("GitHub 사용자 이름을 입력하세요.", text: $username, onEditingChanged: { editing in
                    self.editing = editing
                    if !editing {
                        viewModel.saveUsername(username: username)
                    }
                }, onCommit: {
                    viewModel.submitButtonDidTap(username: username)
                })

                Button {
                    username = ""
                    viewModel.saveUsername(username: "")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .isHidden(username.isEmpty || !editing)
            }
            .padding(16)
            .frame(height: 44)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.brown, lineWidth: 1)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Button {
                viewModel.submitButtonDidTap(username: username)
            } label: {
                Text("확인")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .frame(height: 44)
                    .padding(.horizontal, 24)
                    .contentShape(RoundedRectangle(cornerRadius: 6))
            }
            .disabled(username.isEmpty)
            .buttonStyle(.plain)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.brown)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
        .onAppear {
            username = viewModel.username ?? ""
        }
    }
}

struct UsernameInputView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameInputView(viewModel: UsernameInputViewModel(repository: DummyRepository()))
    }
}

final class UsernameInputViewController: UIHostingController<UsernameInputView>, RouterProtocol {
    
    private let disposeBag = DisposeBag()
    private let viewModel: UsernameInputViewModel
    
    init(viewModel: UsernameInputViewModel) {
        self.viewModel = viewModel
        super.init(rootView: UsernameInputView(viewModel: viewModel))
        bindTrigger()
    }
    
    private func bindTrigger() {
        viewModel.route
            .subscribe(onNext: {
                self.route(to: $0)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.viewDidLoad()
    }
}
