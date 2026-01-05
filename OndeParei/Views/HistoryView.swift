import SwiftUI
import CoreData
import MapKit

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ParkingSession.arrivalDate, ascending: false)],
        predicate: NSPredicate(format: "isActive == false"),
        animation: .default)
    private var history: FetchedResults<ParkingSession>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(history) { session in
                    NavigationLink(destination: HistoryDetailView(session: session)) {
                        HStack {
                            if let data = session.photoData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .clipped()
                            } else {
                                Image(systemName: "map.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.note?.isEmpty ?? true ? "Sem nota" : session.note!)
                                    .font(.headline)
                                
                                if let date = session.arrivalDate {
                                    Text(date, format: .dateTime.day().month().hour().minute())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text(String(format: "Lat: %.4f, Long: %.4f", session.latitude, session.longitude))
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                    .monospaced()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Histórico")
            .overlay {
                if history.isEmpty {
                    ContentUnavailableView("Nenhum histórico", systemImage: "clock.arrow.circlepath", description: Text("Seus estacionamentos antigos aparecerão aqui."))
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { history[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}
struct HistoryDetailView: View {
    let session: ParkingSession
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var position: MapCameraPosition
    
    init(session: ParkingSession) {
        self.session = session
        let center = CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        _position = State(initialValue: .region(region))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Map(position: $position) {
                    Marker("Local Salvo", coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude))
                        .tint(.orange)
                }
                .frame(height: 250)
                .cornerRadius(12)
                .padding(.horizontal)
                
                if let data = session.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .clipped()
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nota:")
                        .font(.caption).foregroundColor(.gray)
                    Text(session.note ?? "Sem observações")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Data do Registro:")
                        .font(.caption).foregroundColor(.gray)
                    Text(session.arrivalDate ?? Date(), style: .date)
                    + Text(" às ")
                    + Text(session.arrivalDate ?? Date(), style: .time)
                }
                .padding(.horizontal)
                
                HStack(spacing: 15) {
                    Button {
                        openInMaps()
                    } label: {
                        Label("Como Chegar", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    Button {
                        reactivateSession()
                    } label: {
                        Label("Reativar Vaga", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                }
                .padding()
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = session.note ?? "Local Histórico"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    private func reactivateSession() {
        session.isActive = true
        try? viewContext.save()
        dismiss()
    }
}
