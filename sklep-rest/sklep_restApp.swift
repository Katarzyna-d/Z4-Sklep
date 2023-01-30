//
//  sklep_restApp.swift
//  sklep-rest
//
//  Created by kprzystalski on 18/01/2021.
//

import SwiftUI
import CoreData

@main
struct sklep_restApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        loadFromAPI()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension sklep_restApp {
    
    func loadFromAPI() {
        let context = persistenceController.container.viewContext
        let serverURL = "https://e6b7-195-82-43-110.eu.ngrok.io"
//        https://ee1f9c582778.ngrok.io/kategoria
        
        let url = URL(string: serverURL)
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
//    kategorie
        let kategoriaEntity = NSEntityDescription.entity(forEntityName: "Kategoria", in: context)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Houston mamy problem")
                return
            }
            
            guard data != nil else {
                print("Nie ma danych")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = json as? [String:Any] {
                    print(object)
                } else if let object = json as? [Any] {
                    for item in object as! [Dictionary<String, AnyObject>] {
                        let title = item["title"] as! String
                        let server_id = item["id"] as! String
                        
                        let kategoria = NSManagedObject(entity: kategoriaEntity!, insertInto: context)
                        
                        kategoria.setValue(title, forKey: "title")
                        kategoria.setValue(server_id, forKey: "server_id")
                        
                        print("Dodano kategorię: \(title) o id: \(server_id)")
                    }
                    try context.save()
                } else {
                    print("Błędny JSON")
                }
                
            } catch {
                print("Problem z pobraniem odpowiedzi")
                return
            }
        })
        task.resume()
        
//        produkty
        
        let produktEntity = NSEntityDescription.entity(forEntityName: "Produkt", in: context)
        
        let task2 = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Houston mamy problem")
                return
            }
            
            guard data != nil else {
                print("Nie ma danych")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = json as? [String:Any] {
                    print(object)
                } else if let object = json as? [Any] {
                    for item in object as! [Dictionary<String, AnyObject>] {
                        let title = item["title"] as! String
                        let desc = item["desc"] as! String
                        
                        let produkt = NSManagedObject(entity: produktEntity!, insertInto: context)
                        
                        produkt.setValue(title, forKey: "title")
                        produkt.setValue(desc, forKey: "desc")
                        
                        print("Dodano produkt: \(title) o id: \(desc)")
                    }
                    try context.save()
                } else {
                    print("Błędny JSON")
                }
                
            } catch {
                print("Problem z pobraniem odpowiedzi")
                return
            }
        })
        task.resume()
    }
}
