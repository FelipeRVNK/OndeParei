import SwiftUI
import MapKit
import CoreData
import PhotosUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel: ParkingViewModel
    
    @State private var photoItem: PhotosPickerItem?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ParkingSession.arrivalDate, ascending: false)],
        predicate: NSPredicate(format: "isActive == true"),
        animation: .default)
    private var activeSession: FetchedResults<ParkingSession>
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ParkingViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    if let session = activeSession.first {
                        Marker("Meu Carro", systemImage: "car.fill", coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude))
                            .tint(.red)
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
                VStack {
                    if let currentSession = activeSession.first {
                        panelParked(session: currentSession)
                    } else {
                        panelToPark()
                    }
                }
            }
            .navigationTitle("Onde Parei?")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
        private func panelParked(session: ParkingSession) -> some View {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "car.fill")
                        .font(.title)
                        .foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("Carro Estacionado")
                            .font(.headline)
                        if let date = session.arrivalDate {
                            Text(date, style: .time).font(.caption).foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                
                if let data = session.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .cornerRadius(10)
                        .clipped()
                }
                
                if let nota = session.note, !nota.isEmpty {
                    Text("📍 \(nota)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8).background(Color.gray.opacity(0.1)).cornerRadius(8)
                }
                
                HStack(spacing: 10) {
                    Button {
                        withAnimation {
                            let carLocation = CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
                            cameraPosition = .region(MKCoordinateRegion(center: carLocation, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)))
                        }
                    } label: {
                        Label("Ver", systemImage: "scope")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)

                    Button {
                        openMapsRoute(lat: session.latitude, long: session.longitude)
                    } label: {
                        Label("Ir até lá", systemImage: "figure.walk")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }
                Button("Sair da Vaga / Finalizar") {
                    viewModel.finishSession(session: session)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding()
        }
    
    private func panelToPark() -> some View {
        VStack(spacing: 15) {
            Text("Vai parar aqui?")
                .font(.headline)
            
            TextField("Nota (Ex: Vaga 42, Setor B)", text: $viewModel.noteText)
                .textFieldStyle(.roundedBorder)
            
            if let data = viewModel.selectedPhotoData, let uiImage = UIImage(data: data) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable().scaledToFill()
                        .frame(height: 100).cornerRadius(8).clipped()
                    
                    Button {
                        viewModel.selectedPhotoData = nil
                        photoItem = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white, .red).font(.title2)
                    }
                    .padding(4)
                }
            } else {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Adicionar Foto")
                    }
                    .foregroundColor(.blue)
                    .padding(8).background(Color.blue.opacity(0.1)).cornerRadius(8)
                }
                .onChange(of: photoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.selectedPhotoData = data
                        }
                    }
                }
            }
            
            if let loc = locationManager.location {
                Button {
                    viewModel.parkCar(location: loc)
                } label: {
                    HStack {
                        Image(systemName: "parkingsign.circle.fill")
                        Text("ESTACIONAR AQUI")
                    }
                    .bold().frame(maxWidth: .infinity).padding()
                    .background(Color.green).foregroundColor(.white).cornerRadius(12)
                }
            } else {
                HStack {
                    ProgressView()
                    Text("Buscando GPS...")
                }
                .frame(maxWidth: .infinity).padding()
                .background(Color.gray.opacity(0.3)).cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
    }
        private func openMapsRoute(lat: Double, long: Double) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = "Meu Carro"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
}
