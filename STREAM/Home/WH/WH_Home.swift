//
//  WH_Home.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct WarehouseNo1: Codable, Identifiable {
    var id: String  {nowhbag }
    var nowhbag: String
}

struct WarehouseNo2: Codable, Identifiable {
    var id: String  {nowhbag }
    var nowhbag: String
}

struct WarehouseNo3: Codable, Identifiable {
    var id: String  {nowhbag }
    var nowhbag: String
}

struct WarehouseNo4: Codable, Identifiable {
    var id: String  {nowhbag }
    var nowhbag: String
}

struct WH_Home: View {
    
    @State private var warehouse1: [WarehouseNo1] = []
    @State private var warehouse2: [WarehouseNo2] = []
    @State private var warehouse3: [WarehouseNo3] = []
    @State private var warehouse4: [WarehouseNo4] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {

                        Color.clear
                            .frame(width: 1)

                        VStack {
                            VStack {
                                HStack {
                                    Text("Warehouse 1")
                                        .font(.system(size: 35))
                                        .bold()
                                }
                                
                                HStack {
                                    
                                    HStack {
                                        VStack{
                                            Image(systemName: "archivebox.circle")
                                                .font(.system(size: 60))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                        
                                        VStack {
                                            Text("\(warehouse1.first?.nowhbag ?? "0")")
                                                .font(.system(size: 40))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                    }
                                }
                                
                                VStack {
                                    NavigationLink {
                                        WH_ViewWh(whno: "1", nobags: "\(warehouse1.first?.nowhbag ?? "0")")
                                    } label: {
                                        Text("View More")
                                            .font(.title2)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                }
                                .frame(width: 200, height: 60)
                                .background(Color.blue.opacity(7))
                                .cornerRadius(20)
                            }
                        }
                        .frame(width: 600, height: 600)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 15))

                        VStack {
                            VStack {
                                HStack {
                                    Text("Warehouse 2")
                                        .font(.system(size: 35))
                                        .bold()
                                }
                                HStack {
                                    
                                    HStack {
                                        VStack{
                                            Image(systemName: "archivebox.circle")
                                                .font(.system(size: 60))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                        
                                        VStack {
                                            Text("\(warehouse2.first?.nowhbag ?? "0")")
                                                .font(.system(size: 40))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                    }
                                }
                                VStack {
                                    NavigationLink {
                                        WH_ViewWh(whno: "2", nobags: "\(warehouse2.first?.nowhbag ?? "0")")
                                    } label: {
                                        Text("View More")
                                            .font(.title2)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                }
                                .frame(width: 200, height: 60)
                                .background(Color.blue.opacity(7))
                                .cornerRadius(20)
                            }
                        }
                        .frame(width: 600, height: 600)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        VStack {
                            VStack {
                                HStack {
                                    Text("Warehouse 3")
                                        .font(.system(size: 35))
                                        .bold()
                                }
                                HStack {
                                    
                                    HStack {
                                        VStack{
                                            Image(systemName: "archivebox.circle")
                                                .font(.system(size: 60))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                        
                                        VStack {
                                            Text("\(warehouse3.first?.nowhbag ?? "0")")
                                                .font(.system(size: 40))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                    }
                                }
                                VStack {
                                    NavigationLink {
                                        WH_ViewWh(whno: "3", nobags: "\(warehouse3.first?.nowhbag ?? "0")")
                                    } label: {
                                        Text("View More")
                                            .font(.title2)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                }
                                .frame(width: 200, height: 60)
                                .background(Color.blue.opacity(7))
                                .cornerRadius(20)
                            }
                        }
                        .frame(width: 600, height: 600)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        VStack {
                            VStack {
                                HStack {
                                    Text("JENTEC")
                                        .font(.system(size: 35))
                                        .bold()
                                }
                                HStack {
                                    
                                    HStack {
                                        VStack{
                                            Image(systemName: "archivebox.circle")
                                                .font(.system(size: 60))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                        
                                        VStack {
                                            Text("\(warehouse4.first?.nowhbag ?? "0")")
                                                .font(.system(size: 40))
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color.blue.opacity(0.3))
                                        .cornerRadius(20)
                                    }
                                    
                                }
                                VStack {
                                    NavigationLink {
                                        WH_ViewWh(whno: "JENTEC", nobags: "\(warehouse4.first?.nowhbag ?? "0")")
                                    } label: {
                                        Text("View More")
                                            .font(.title2)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                }
                                .frame(width: 200, height: 60)
                                .background(Color.blue.opacity(7))
                                .cornerRadius(20)
                            }
                        }
                        .frame(width: 600, height: 600)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding(20)
                }
            }
        }
        .onAppear() {
            countInHouseBags1()
            countInHouseBags2()
            countInHouseBags3()
            countInHouseBags4()
        }
    }
    
    func countInHouseBags1() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/countInHouseBags.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=1"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseNo1].self, from: data)

                DispatchQueue.main.async {
                    self.warehouse1 = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func countInHouseBags2() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/countInHouseBags.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=2"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseNo2].self, from: data)

                DispatchQueue.main.async {
                    self.warehouse2 = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func countInHouseBags3() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/countInHouseBags.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=3"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseNo3].self, from: data)

                DispatchQueue.main.async {
                    self.warehouse3 = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func countInHouseBags4() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/countInHouseBags.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=JENTEC"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseNo4].self, from: data)

                DispatchQueue.main.async {
                    self.warehouse4 = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
}

#Preview {
    WH_Home()
}
