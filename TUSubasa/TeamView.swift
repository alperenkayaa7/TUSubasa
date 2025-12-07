import SwiftUI

struct TeamView: View {
    @StateObject var teamManager = TeamManager.shared
    @State private var showCreateSheet = false
    @State private var showJoinSheet = false
    @State private var inputName = ""
    @State private var inputCode = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let team = teamManager.myTeam {
                // --- TAKIM EKRANI (ÜYESİN) ---
                VStack(spacing: 20) {
                    // Üst Bilgi
                    VStack {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 60)).foregroundColor(.cyan)
                        Text(team.name).font(.largeTitle).bold().foregroundColor(.white)
                        
                        HStack {
                            Text("Katılım Kodu:").foregroundColor(.gray)
                            Text(team.joinCode)
                                .font(.title2).bold().foregroundColor(.yellow)
                                .onTapGesture {
                                    UIPasteboard.general.string = team.joinCode // Kopyala
                                }
                            Image(systemName: "doc.on.doc").font(.caption).foregroundColor(.gray)
                        }
                        .padding(10).background(Color.white.opacity(0.1)).cornerRadius(10)
                    }
                    .padding(.top, 30)
                    
                    // Üyeler Listesi
                    List {
                        Section(header: Text("EKİP ÜYELERİ (\(teamManager.teamMembers.count))")) {
                            ForEach(Array(teamManager.teamMembers.enumerated()), id: \.element.id) { index, member in
                                HStack {
                                    Text("#\(index + 1)").font(.caption).foregroundColor(.gray).frame(width: 30)
                                    
                                    // Resim (Varsa)
                                    if let url = member.profileImageURL, !url.isEmpty {
                                        AsyncImage(url: URL(string: url)) { i in i.resizable().scaledToFill() } placeholder: { Color.gray }
                                            .frame(width: 30, height: 30).clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill").foregroundColor(.gray)
                                    }
                                    
                                    Text(member.username).foregroundColor(.white)
                                    Spacer()
                                    Text("\(member.totalScore) P").font(.caption).bold().foregroundColor(.yellow)
                                }
                                .listRowBackground(Color.white.opacity(0.05))
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    // Ayrıl Butonu
                    Button("Takımdan Ayrıl") {
                        teamManager.leaveTeam { }
                    }
                    .foregroundColor(.red).padding()
                }
            } else {
                // --- BOŞ EKRAN (TAKIM YOK) ---
                VStack(spacing: 30) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 80)).foregroundColor(.gray)
                    
                    Text("Bir Ekibin Yok mu?")
                        .font(.title).bold().foregroundColor(.white)
                    
                    Text("Arkadaşlarınla yarışmak ve yardımlaşmak için bir takıma katıl veya yeni bir tane kur.")
                        .multilineTextAlignment(.center).foregroundColor(.gray).padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button(action: { showCreateSheet = true }) {
                            Text("Takım Kur")
                                .bold().padding().frame(width: 140)
                                .background(Color.cyan).foregroundColor(.black).cornerRadius(12)
                        }
                        
                        Button(action: { showJoinSheet = true }) {
                            Text("Koda Katıl")
                                .bold().padding().frame(width: 140)
                                .background(Color.white.opacity(0.1)).foregroundColor(.white).cornerRadius(12)
                        }
                    }
                }
            }
        }
        .onAppear { teamManager.fetchMyTeam() }
        
        // Pencereler
        .sheet(isPresented: $showCreateSheet) {
            VStack(spacing: 20) {
                Text("Yeni Takım Kur").font(.title2).bold()
                TextField("Takım Adı (Örn: Cerrahpaşa 24)", text: $inputName)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Button("Oluştur") {
                    teamManager.createTeam(name: inputName) { success in
                        if success { showCreateSheet = false }
                    }
                }.buttonStyle(.borderedProminent)
            }.presentationDetents([.height(250)])
        }
        .sheet(isPresented: $showJoinSheet) {
            VStack(spacing: 20) {
                Text("Takıma Katıl").font(.title2).bold()
                TextField("Katılım Kodu (Örn: X9Y2)", text: $inputCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Button("Katıl") {
                    teamManager.joinTeam(code: inputCode) { success in
                        if success { showJoinSheet = false }
                    }
                }.buttonStyle(.borderedProminent)
            }.presentationDetents([.height(250)])
        }
    }
}
