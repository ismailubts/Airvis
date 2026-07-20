import SwiftUI

struct ContentView: View {
    @EnvironmentObject var callManager: CallManager
    // Default to localhost so the simulator works out of the box; on a real
    // phone the user puts in the Mac's Tailscale IP (e.g. 100.x.x.x:7860).
    @AppStorage("serverURL") private var serverURL: String = "http://localhost:7860"

    private let ink = Color(red: 0.10, green: 0.14, blue: 0.20)
    private let mist = Color(red: 0.93, green: 0.95, blue: 0.94)
    private let teal = Color(red: 0.05, green: 0.48, blue: 0.44)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.94, blue: 0.93),
                    mist,
                    Color(red: 0.95, green: 0.92, blue: 0.86),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Airvis")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(ink)
                    .tracking(-1)
                Text(callManager.statusText)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 40)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Mac server URL").font(.caption).foregroundColor(.secondary)
                    TextField("http://100.x.x.x:7860", text: $serverURL)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .disabled(callManager.isInCall)
                }

                if callManager.isInCall {
                    HStack(spacing: 10) {
                        Button {
                            callManager.toggleMute()
                        } label: {
                            Label(
                                callManager.muted ? "Muted" : "Mic on",
                                systemImage: callManager.muted ? "mic.slash.fill" : "mic.fill"
                            )
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .buttonStyle(.bordered)
                        .tint(callManager.muted ? .orange : .gray)

                        Button {
                            callManager.toggleSpeaker()
                        } label: {
                            Label(
                                callManager.speakerOn ? "Speaker on" : "Speaker off",
                                systemImage: callManager.speakerOn ? "speaker.wave.3.fill" : "speaker.slash.fill"
                            )
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .buttonStyle(.bordered)
                        .tint(callManager.speakerOn ? teal : .gray)
                    }

                    Button(role: .destructive) {
                        callManager.endCall()
                    } label: {
                        Label("Hang up", systemImage: "phone.down.fill")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Button {
                        callManager.startCall(serverURL: serverURL)
                    } label: {
                        Label("Call Airvis", systemImage: "phone.fill")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(teal)
                }
            }
            .padding(32)
        }
    }
}

#Preview {
    ContentView().environmentObject(CallManager())
}
