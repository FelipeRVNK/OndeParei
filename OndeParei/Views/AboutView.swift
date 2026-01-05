import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Desenvolvedor")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Felipe D. Schmidt")
                                .font(.headline)
                            Text(" Desenvolvimento de Aplicativos Móveis / Disciplina IOS")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Sobre o App")) {
                    Text("Onde Parei? é um assistente de estacionamento inteligente que utiliza Core Data para persistência local e MapKit para geolocalização.")
                        .font(.body)
                        .padding(.vertical, 5)
                }
                
                Section(header: Text("Versão")) {
                    HStack {
                        Text("Versão")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Sobre")
        }
    }
}

#Preview {
    AboutView()
}
