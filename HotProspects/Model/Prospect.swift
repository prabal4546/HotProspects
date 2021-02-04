//
//  Prospect.swift
//  HotProspects
//
//  Created by PRABALJIT WALIA     on 04/02/21.
//

import SwiftUI
class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}
class Prospects: ObservableObject {
    @Published var people: [Prospect]

    init() {
        self.people = []
    }
}
