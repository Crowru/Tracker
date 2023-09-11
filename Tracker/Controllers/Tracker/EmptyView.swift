//
//  EmptyView.swift
//  Tracker
//
//  Created by Руслан  on 04.09.2023.
//

import UIKit

final class EmptyView: UIView {
    private lazy var placeholderImage: UIImageView = {
        let image = UIImage(named: "errorImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    init(frame: CGRect, image: UIImage?, text: String) {
        super.init(frame: frame)
        self.placeholderImage.image = image
        self.textLabel.text = text
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layouts
private extension EmptyView {
    func setupViews() {
        self.backgroundColor = .white
        
        addSubviews(placeholderImage, textLabel)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant:  8),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
