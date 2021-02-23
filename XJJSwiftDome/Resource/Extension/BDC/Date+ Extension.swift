//
//  Date+ Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import Foundation

extension Date {
    func dateString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
