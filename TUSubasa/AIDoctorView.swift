import SwiftUI
import PhotosUI
import UIKit

struct AIDoctorView: View {
    @StateObject var aiManager = AIDoctorManager.shared
    @State private var inputText = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showCamera = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // SOHBET ALANI
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                if aiManager.chatHistory.isEmpty {
                                    VStack(spacing: 10) {
                                        Image(systemName: "stethoscope.circle.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.cyan)
                                        Text("Merhaba Doktor!")
                                            .font(.title2).bold().foregroundColor(.white)
                                        Text("Anlamadığın bir TUS sorusu mu var?\nFotoğrafını çek gönder, birlikte çözelim.")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                    .padding(.top, 50)
                                }
                                
                                ForEach(aiManager.chatHistory) { msg in
                                    ChatBubble(message: msg)
                                        .id(msg.id)
                                }
                                
                                if aiManager.isLoading {
                                    HStack {
                                        ProgressView().tint(.cyan)
                                        Text("Dr. AI düşünüyor...").font(.caption).foregroundColor(.gray)
                                    }.padding()
                                }
                                
                                // HATA MESAJI ALANI (YENİ)
                                if let error = aiManager.errorMessage {
                                    Text("HATA: \(error)")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .padding()
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: aiManager.chatHistory.count) { _ in
                            if let lastId = aiManager.chatHistory.last?.id {
                                withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                            }
                        }
                    }
                    
                    // ALT GİRİŞ ALANI
                    HStack(spacing: 10) {
                        // 1. GALERİ
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title2).foregroundColor(.cyan)
                        }
                        
                        // 2. KAMERA
                        Button(action: { showCamera = true }) {
                            Image(systemName: "camera.fill")
                                .font(.title2).foregroundColor(.cyan)
                        }
                        
                        // Yazı Alanı
                        TextField("Bir soru sor...", text: $inputText)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .focused($isFocused)
                        
                        // Gönder Butonu
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                                .foregroundColor(inputText.isEmpty ? .gray : .cyan)
                        }
                        .disabled(inputText.isEmpty && !aiManager.isLoading)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.2))
                }
            }
            .navigationTitle("Dr. AI Asistan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Temizle") { aiManager.clearHistory() }.foregroundColor(.red)
                }
            }
            .onChange(of: selectedItem) { _ in
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await aiManager.sendImage(uiImage)
                        selectedItem = nil
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: .init(get: { nil }, set: { img in
                    if let img = img {
                        Task { await aiManager.sendImage(img) }
                    }
                }), sourceType: .camera)
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let text = inputText
        inputText = ""
        Task {
            await aiManager.sendMessage(text)
        }
    }
}

// Kamera ve ChatBubble kodları aynı kalabilir (Dosyanın altında zaten vardır)
// ...
