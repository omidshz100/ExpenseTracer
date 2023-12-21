//
//  TintColor.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import Foundation
import SwiftUI


struct TintColor:Identifiable {
    var id:UUID = UUID()
    var color:String
    var value:Color
}

let tints:[TintColor] = [
    TintColor(color: "red", value: .red),
    TintColor(color: "Blue", value: .blue),
    TintColor(color: "Pink", value: .pink),
    TintColor(color: "purple", value: .purple),
    TintColor(color: "Brown", value: .brown),
    TintColor(color: "Orange", value: .orange)
]
