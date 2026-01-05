import Foundation
import CoreData
import CoreLocation
import UIKit
import Combine

class ParkingViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    @Published var noteText: String = ""
    @Published var selectedPhotoData: Data? = nil
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func parkCar(location: CLLocation) {
        let newSession = ParkingSession(context: viewContext)
        newSession.id = UUID()
        newSession.latitude = location.coordinate.latitude
        newSession.longitude = location.coordinate.longitude
        newSession.note = noteText
        newSession.arrivalDate = Date()
        newSession.photoData = selectedPhotoData
        newSession.isActive = true
        
        saveContext()
    }
    
    func finishSession(session: ParkingSession) {
        session.isActive = false
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            noteText = ""
            selectedPhotoData = nil
        } catch {
            print("Erro ao salvar: \(error.localizedDescription)")
        }
    }
}
