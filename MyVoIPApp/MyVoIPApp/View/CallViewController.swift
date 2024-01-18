//
//  CallViewController.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 15/1/24.
//


import UIKit
import Combine
import AgoraRtcKit
import Lottie

class CallViewController: UIViewController, UIViewControllerProtocol{

    private let user: UserEntity
    private let viewModel: CallViewModel

    private var engine: AgoraRtcEngineKit?

    // UI Elements
    private let participantsLabel: UILabel = {
        var label = UILabel()
        label.text = "Participants: -"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let channelNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Channel: -"
        return label
    }()
    
    private var animationView: LottieAnimationView = {
       var animation = LottieAnimationView()
        animation = LottieAnimationView(name: "Call-Animation")
        animation.loopMode = .loop
        animation.contentMode = .center
        animation.isHidden = false
        return animation
    }()
    
    private let muteButton: UIButton = {
        let button = UIButton.roundedButton()
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.setRoundedButtonRadious(25)
        button.setEmoji("🎙️")
        return button
    }()
    
    private let speakerButton: UIButton = {
        let button = UIButton.roundedButton()
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.setRoundedButtonRadious(25)
        button.setEmoji("🔊")
        return button
    }()
    
    private let endCallButton: UIButton = {
        let button = UIButton.roundedButton()
        button.layer.borderColor = UIColor.red.cgColor
        button.setEmoji("🔚")
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    init(viewModel: CallViewModel, user: UserEntity) {
        self.viewModel = viewModel
        self.user = user
        viewModel.prepareForCall(withUser: user)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        view.backgroundColor = UIColor.white

        animationView.backgroundColor = view.backgroundColor
        animationView.center = self.view.center

        endCallButton.addTarget(self, action: #selector(endCallButtonTapped), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)
        speakerButton.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)

        view.addSubview(animationView)
        view.addSubview(participantsLabel)
        view.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(speakerButton)
        buttonsStackView.addArrangedSubview(endCallButton)
        buttonsStackView.addArrangedSubview(muteButton)

        NSLayoutConstraint.activate([
            participantsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            participantsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),

            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),

            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        animationView.play()

        endCallButton.addTarget(self, action: #selector(endCallButtonTapped), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)
        speakerButton.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.onActiveUsersChanged = { [weak self] in
          self?.updateActiveUsersDisplay()
        }
    }

    private func updateActiveUsersDisplay() {
        let activeUsersText = viewModel.activeUsers
        participantsLabel.text = "Active Users: \(activeUsersText)"
    }

    @objc private func endCallButtonTapped() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        
        viewModel.exitCall() { success in
            if success {
                let userListController = UserListViewController(viewModel: self.container.userListViewModel)
                navigationController.setViewControllers([userListController], animated: false)
            }
        }
    }
    
    @objc private func muteButtonTapped() {
        viewModel.toggleMute()
        muteButton.setTitle( viewModel.isMuted ? "📴" : "🎙️", for: .normal)
        muteButton.backgroundColor = viewModel.isMuted ? UIColor.lightGray : view.backgroundColor
    }
    
    @objc private func speakerTapped() {
        viewModel.toggleSpeaker()
        speakerButton.titleLabel?.font = UIFont.systemFont(ofSize: viewModel.isSpeakerOn ? 30 : 20)
    }
}
