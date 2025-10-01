//
//  ContentView.swift
//  PruebasLibreriaSPM
//
//  Created by ALDRICH GONZALEZ GOMEZ on 29/09/25.
//

// AppointmentSchedulerDemo/Views/ContentView.swift
import SwiftUI
import AppointmentSchedulerSDK

struct ContentView: View {
    @State private var client: ClientInfo? = nil
    @StateObject private var scheduler = AppointmentScheduler() 

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let c = client {
                    LabeledContent("Cliente") { Text("\(c.name) · \(c.email)") }
                } else {
                    Text("Cargando perfil...")
                }

                Divider()

                AppointmentSchedulerView(
                    scheduler: scheduler,
                    prefilledClient: client
                )
            }
            .padding()
            .navigationTitle("Demo Scheduler")
        }
        .task { await loadClient() }
    }

    private func loadClient() async {
        do {
            let user = try await DemoAPIClient().fetchUser(id: 1)
            await MainActor.run {
                self.client = ClientInfo(name: user.name, email: user.email)
            }
        } catch {
            await MainActor.run {
                self.client = ClientInfo(name: "Invitado", email: "guest@example.com")
            }
            print("[Demo] Error fetching user: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
