import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            HomeView(context: viewContext)
                .tabItem { Label("Mapa", systemImage: "map") }
            
            HistoryView()
                .tabItem { Label("Histórico", systemImage: "list.bullet") }

            AboutView()
                .tabItem {
                    Label("Sobre", systemImage: "info.circle")
                }
        }
    }
}
