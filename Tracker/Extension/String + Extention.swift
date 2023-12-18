//
//  String + Extention.swift
//  Tracker
//
//  Created by Руслан  on 18.09.2023.
//

import Foundation

extension String {
    func localised() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          value: self,
                          comment: self)
    }
}
