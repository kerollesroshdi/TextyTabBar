//
//  KRTabBar.swift
//  TextyTabBarController
//
//  Created by Kerolles Roshdi on 2/14/20.
//  Copyright © 2020 Kerolles Roshdi. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class TextyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var selectedTab: Int = 0
    
    private var buttons = [UIButton]()
    private var buttonsColors = [UIColor]()
    
    private var indexViewWidthAnchor: NSLayoutConstraint!
    private var indexViewCenterXAnchor: NSLayoutConstraint!
    
    private let customTabBarView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let indexView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .orange
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override var viewControllers: [UIViewController]? {
        didSet {
            createButtonsStack(viewControllers!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        addCustomTabBarView()
        tabBar.tintColor = .black
        createButtonsStack(viewControllers!)
        autolayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.layer.cornerRadius = customTabBarView.frame.size.height / 4.5
        indexView.layer.cornerRadius = indexView.frame.size.height / 2
        indexView.backgroundColor = buttonsColors[selectedTab]
    }
    
    private func createButtonsStack(_ viewControllers: [UIViewController]) {
        
        let font = UIFont(name: "Avenir-Heavy", size: 16)
        
        // clean :
        buttons.removeAll()
        buttonsColors.removeAll()
        
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let tabBarItem = viewController.tabBarItem as? TextyTabBarItem {
                if let color = tabBarItem.color {
                    buttonsColors.append(color)
                }
            } else {
                fatalError("set tabBarItem number(\(index + 1)) Class as TextyTabBarItem and set its color, image and title")
            }
            let button = UIButton()
            button.tag = index
            button.addTarget(self, action: #selector(didSelectIndex(sender:)), for: .touchUpInside)
            button.setImage(viewController.tabBarItem.image, for: .normal)
            button.imageView?.tintColor = .black
            button.titleLabel?.font = font
            button.setTitleColor(.black, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: 0)
            if index == 0 {
                button.setTitle(viewController.tabBarItem.title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.imageView?.tintColor = .white
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        view.setNeedsLayout()
    }
    
    private func autolayout() {
        NSLayoutConstraint.activate([
            customTabBarView.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
            customTabBarView.heightAnchor.constraint(equalTo: tabBar.heightAnchor, constant: 20),
            customTabBarView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            customTabBarView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor, constant: -15),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.topAnchor.constraint(equalTo: customTabBarView.topAnchor, constant: 10),
            indexView.heightAnchor.constraint(equalToConstant: customTabBarView.bounds.height),
            indexView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
         ])
        
        indexViewCenterXAnchor = indexView.centerXAnchor.constraint(equalTo: buttons[selectedTab].centerXAnchor)
        indexViewCenterXAnchor.isActive = true
        
        indexViewWidthAnchor = indexView.widthAnchor.constraint(equalTo: buttons[selectedTab].widthAnchor, constant: -20)
        indexViewWidthAnchor.isActive = true
    }
    
    private func addCustomTabBarView() {
        customTabBarView.frame = tabBar.frame
        indexView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        
        view.bringSubviewToFront(self.tabBar)
        
        customTabBarView.addSubview(indexView)
        customTabBarView.addSubview(stackView)
        
    }
    
    @objc private func didSelectIndex(sender: UIButton) {
        let index = sender.tag
        self.selectedIndex = index
        self.selectedTab = index
                
        for (indx, button) in self.buttons.enumerated() {
            if indx != index {
                button.setTitle(nil, for: .normal)
                button.imageView?.tintColor = .black
            } else {
                button.setTitle(self.viewControllers![indx].tabBarItem.title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.imageView?.tintColor = .white
            }
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.indexView.backgroundColor = self.buttonsColors[index]
                        
            self.indexViewWidthAnchor.isActive = false
            self.indexViewWidthAnchor = nil
            self.indexViewWidthAnchor = self.indexView.widthAnchor.constraint(equalTo: self.buttons[index].widthAnchor, constant: -20)
            self.indexViewWidthAnchor.isActive = true
            
            self.indexViewCenterXAnchor.isActive = false
            self.indexViewCenterXAnchor = nil
            self.indexViewCenterXAnchor = self.indexView.centerXAnchor.constraint(equalTo: self.buttons[index].centerXAnchor)
            self.indexViewCenterXAnchor.isActive = true
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    // Delegate:
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let items = tabBar.items,
            let index = items.firstIndex(of: item)
            else {
                print("not found")
                return
        }
        didSelectIndex(sender: self.buttons[index])
    }
    
}
