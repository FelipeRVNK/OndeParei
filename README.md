# 🚗 Onde Parei? - Assistente de Estacionamento

O **Onde Parei** é um aplicativo nativo para iOS desenvolvido em Swift e SwiftUI. Ele foi projetado para ajudar os utilizadores a registar e localizar os seus veículos estacionados de forma simples e eficiente, utilizando tecnologias de geolocalização, persistência local e integração com mapas.

---

## 🌟 Funcionalidades Principais

* **📍 Geolocalização em Tempo Real:** Captura a posição exata (latitude e longitude) no momento do estacionamento usando **Core Location**.
* **🗺️ Mapa Interativo:** Visualização da localização atual do utilizador e do veículo através do **MapKit**.
* **📸 Registo com Fotos:** Permite anexar uma foto do local ou pontos de referência utilizando **PhotosUI**.
* **📝 Notas Personalizadas:** Campo para anotações adicionais (ex: "Piso G2, Lugar 15").
* **💾 Persistência de Dados:** Todos os registos são salvos localmente via **Core Data**, permitindo que as informações sobrevivam ao fecho ou reinício do app.
* **🚶 Guia de Retorno:** Botão "Como Chegar" que integra com o Apple Maps para traçar rotas a pé até ao veículo.
* **📜 Histórico Completo:** Lista de todos os estacionamentos anteriores com detalhes, fotos e opção de reativar um lugar finalizado por engano.

---

## 🛠️ Tecnologias e Frameworks

* **Swift & SwiftUI:** Linguagem e framework moderno para construção da interface.
* **Core Data:** Gestão da base de dados local e persistência de média (Binary Data).
* **MapKit:** Exibição e manipulação de mapas e anotações.
* **Core Location:** Gestão de permissões e serviços de localização/GPS.
* **PhotosUI:** Integração nativa para seleção de imagens da galeria.
* **Combine:** Utilizado para reatividade entre o gestor de localização e as views.

---

## 🏗️ Arquitetura do Projeto

O projeto segue o padrão **MVVM (Model-View-ViewModel)**, organizado da seguinte forma:

* **📂 App:** Ciclo de vida do aplicativo e configuração do container de persistência.
* **📂 Model:** Definição do modelo de dados do Core Data (`ParkingSession`).
* **📂 Services:** Lógica de baixo nível para serviços do sistema, como o `LocationManager`.
* **📂 ViewModels:** Camada intermédia que processa os dados e gere o estado da interface (`ParkingViewModel`).
* **📂 Views:** Componentes visuais e ecrãs do utilizador (Home, Histórico, Detalhes e Sobre).

---

## 🚀 Como Executar

1.  Abra o projeto no **Xcode 15+**.
2.  Certifique-se de que o destino selecionado seja um **iPhone com iOS 17.0+**.
3.  Pressione `Command + R` para compilar e correr o app.
4.  **Nota para Simulador:** Para testar o GPS no simulador, vá ao menu `Features > Location` e selecione um ponto como `Apple Park` ou `City Run`.

---


*Este projeto foi desenvolvido com foco em boas práticas de arquitetura e utilização de frameworks nativos da Apple.*
