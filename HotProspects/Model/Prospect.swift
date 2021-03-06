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
    static func < (lhs:Prospect, rhs:Prospect)->Bool{
        lhs.name < rhs.name
    }


}
class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let saveKey = "SavedData"


    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Prospect].self,from:data){
                self.people = decoded
                return
            }
        }
        self.people = []
    }
    func add(_ prospect:Prospect){
        people.append(prospect)
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    func toggle(_ prospect:Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    func delete(_ indexSet: IndexSet){
        self.people.remove(atOffsets: indexSet)
        save()
    }
}
