//
//  ConstraintsViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.07.2022.
//

import UIKit

class ConstraintsViewController: UIViewController {
    var regularConstraints: [NSLayoutConstraint] = []
    var compactConstraints: [NSLayoutConstraint] = []
    var sharedConstraints: [NSLayoutConstraint] = []
    
    private lazy var viewContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .gray.withAlphaComponent(0.5)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var image1: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "appleLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var image2: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "retroStyle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    func setupUI() {
        view.addSubview(viewContainer)
        viewContainer.addSubview(image1)
        viewContainer.addSubview(image2)
    }
    
//    func setupConstraints() {
//        sharedConstraints.append(contentsOf: [
//            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
//            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
//            viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
//            viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
//
//            image1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            image1.topAnchor.constraint(equalTo: view.topAnchor),
//            image2.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            image2.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//
//        regularConstraints.append(contentsOf: [
//            image1.trailingAnchor.constraint(equalTo: image2.leadingAnchor, constant: -10),
//            image1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            image2.topAnchor.constraint(equalTo: view.topAnchor)
//        ])
//
//        compactConstraints.append(contentsOf: [
//            image1.bottomAnchor.constraint(equalTo: image2.topAnchor, constant: -10),
//            image1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            image2.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        ])
//    }
   
    func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),

            image1.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            image1.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            image2.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            image2.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)
        ])

        regularConstraints.append(contentsOf: [
            image1.widthAnchor.constraint(equalToConstant: 100),
            image1.heightAnchor.constraint(equalToConstant: 100),
            image2.widthAnchor.constraint(equalToConstant: 100),
            image2.heightAnchor.constraint(equalToConstant: 100),
            image1.trailingAnchor.constraint(equalTo: image2.leadingAnchor, constant: -10),
            image1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            image2.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        compactConstraints.append(contentsOf: [
            image1.widthAnchor.constraint(equalToConstant: 100),
            image1.heightAnchor.constraint(equalToConstant: 100),
            image2.widthAnchor.constraint(equalToConstant: 100),
            image2.heightAnchor.constraint(equalToConstant: 100),
            image1.bottomAnchor.constraint(greaterThanOrEqualTo: image2.topAnchor),
            image1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image2.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if !regularConstraints.isEmpty && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
            print("Image1 frame size is \(image1.frame.size)")
            print("Image2 frame size is \(image2.frame.size)")
        } else {
            NSLayoutConstraint.activate(regularConstraints)
            print("Image1 frame size is \(image1.frame.size)")
            print("Image2 frame size is \(image2.frame.size)")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
}
