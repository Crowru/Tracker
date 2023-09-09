//
//  SubtitledTableViewCell.swift
//  Tracker
//
//  Created by Руслан  on 04.09.2023.
//

import UIKit

final class SubtitledTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
