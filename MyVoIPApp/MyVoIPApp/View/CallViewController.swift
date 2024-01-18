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

class CallViewController: UIViewController, UIViewControllerProtocol, AgoraRtcEngineDelegate {

    private let user: UserEntity
    private let viewModel: CallViewModel

    private var engine: AgoraRtcEngineKit?

    // UI Elements
    private let participantsLabel: UILabel = {
        var label = UILabel()
        label.text = "Participants: -"
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
        viewModel.setupAgoraEngine(delegate: self)
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
        
        endCallButton.addTarget(self, action: #selector(endCallTapped), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        speakerButton.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)

        view.addSubview(animationView)
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(speakerButton)
        buttonsStackView.addArrangedSubview(endCallButton)
        buttonsStackView.addArrangedSubview(muteButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        animationView.play()

        endCallButton.addTarget(self, action: #selector(endCallButtonTapped), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        speakerButton.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)
    }
    
    @objc private func endCallButtonTapped() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)

        //let callViewController = CallViewController(viewModel: self.container.callViewModel, user: currentUser!)
        //navigationController.setViewControllers([callViewController], animated: true)
    }
    
    @objc private func endCallTapped() {
        //viewModel.endCall()
    }
    
    @objc private func muteTapped() {
        //viewModel.toggleMute()
        // Actualiza la UI según sea necesario, por ejemplo cambiando el título del botón
        //let newTitle = viewModel.isMuted ? "Unmute" : "Mute"
        //muteButton.setTitle(newTitle, for: .normal)
    }
    
    @objc private func speakerTapped() {
        //viewModel.toggleSpeaker()
        // Actualiza la UI según sea necesario, por ejemplo cambiando el título del botón
        //let newTitle = viewModel.isSpeakerOn ? "Speaker Off" : "Speaker On"
        //speakerButton.setTitle(newTitle, for: .normal)
    }
    
    func rtcEngine(
        _ engine: AgoraRtcEngineKit, didJoinChannel channel: String,
        withUid uid: UInt, elapsed: Int
    ) {
        // The delegate is telling us that the local user has successfully joined the channel.
        viewModel.localUserId = uid
        viewModel.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // The delegate is telling us that a remote user has joined the channel.
        viewModel.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // The delegate is telling us that a remote user has left the channel.
        viewModel.allUsers.remove(uid)
    }
}
