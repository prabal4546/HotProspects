//
//  ProspectView.swift
//  HotProspects
//
//  Created by PRABALJIT WALIA     on 04/02/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType{
        case contacted, uncontacted, none
    }
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var ShowingActionSheet = false
    
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
                   List {
                       ForEach(filteredProspects) { prospect in
                           VStack(alignment: .leading) {
                            HStack{
                                Text(prospect.name)
                                .font(.headline)
                                if prospect.isContacted{
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                                else{
                                    Image(systemName: "questionmark.diamond")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            }
                               Text(prospect.emailAddress)
                                   .foregroundColor(.secondary)
        
                           }
                           .contextMenu {
                               Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                                   self.prospects.toggle(prospect)
                               }

                               if !prospect.isContacted {
                                   Button("Remind Me") {
                                       self.addNotification(for: prospect)
                                   }
                               }
                           }
                       }
                   }
                   .navigationBarTitle(title)
                   .navigationBarItems(
                    leading: Button(action:{
                    //more code to come
                    self.ShowingActionSheet = true
                   }){
                    Image(systemName:"list.and.film")
                    Text("Sort")
                   },
                    trailing:Button(action: {
                    self.isShowingScanner = true
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                } )
                   .actionSheet(isPresented: $ShowingActionSheet) {
                       ActionSheet(title: Text("Sort"), message: Text("Sort by"), buttons: [
                           .default(Text("Name")),
                           .default(Text("Most Recent")),
                           .cancel()
                       ])
                   }
//                   .navigationBarItems(trailing: Button(action: {
//                       self.isShowingScanner = true
//                   }) {
//                       Image(systemName: "qrcode.viewfinder")
//                       Text("Scan")
//                   })
                   .sheet(isPresented: $isShowingScanner) {
                       CodeScannerView(codeTypes: [.qr], simulatedData: "Nick Caldwell\ncald@gmail.com", completion: self.handleScan)
                   }
                   
            
            
               //
               }
           }

    func handleScan(result: Result<String,CodeScannerView.ScanError>){
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.add(person)
        case .failure(let error):
            print("scanning failed, \(error.localizedDescription)")
        }
    }
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }

        // more code to come
        center.getNotificationSettings{settings in
            if settings.authorizationStatus == .authorized{
                addRequest()
            }else{
                center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
                    if success{
                        addRequest()
                    }else{
                        print("oh oh..")
                    }
                })
            }
        }
        
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}

