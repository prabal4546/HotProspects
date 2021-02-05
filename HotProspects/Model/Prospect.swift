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
    fileprivate(set) var isContacted = false
}
class Prospects: ObservableObject {
    @Published var people: [Prospect]

    init() {
        if let data = UserDefaults.standard.data(forKey: "SavedData"){
            if let decoded = try? JSONDecoder().decode([Prospect].self,from:data){
                self.people = decoded
                return
            }
        }
        self.people = []
    }
    func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    func toggle(_ prospect:Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
