//
//  ProspectView.swift
//  HotProspects
//
//  Created by PRABALJIT WALIA     on 04/02/21.
//

import SwiftUI

struct ProspectsView: View {
    enum FilterType{
        case contacted, uncontacted, none
    }
    
    @EnvironmentObject var prospects: Prospects
    
    let filter:FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }

    var body: some View {
        NavigationView {
            List{
                ForEach(filteredProspects){prospect in
                    VStack(alignment:.leading){
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
                .navigationBarTitle(title)
                .navigationBarItems(trailing:Button(action:{
                    let prospect = Prospect()
                    prospect.name = "Prabal"
                    prospect.emailAddress = ""
                    self.prospects.people.append(prospect)
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
