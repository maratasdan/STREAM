//
//  Dashboard.swift
//  STREAM
//
//  Created by Danxd on 7/6/26.
//

import SwiftUI

struct Dashboard: View {
    
    @State private var phase: CGFloat = 0
    @State private var isPressed: Bool = false
    @State private var x: CGFloat = -120
    
    @State private var activeProcess: String = "Receiving"
    @State private var move = false
    @State private var blink = false
    @State private var blink2 = false
    @State private var blink3 = false
    @State private var blink4 = false
    @State private var blink5 = false
    
    @State private var goToR_RMF: Bool = false
    @State private var goToDrying: Bool = false
    @State private var goToShelling: Bool = false
    @State private var goToCoditioning: Bool = false
    @State private var goToWarehouse: Bool = false
    @State private var goToTruckers: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: true) {
                ZStack {
                    //                GeometryReader { geo in
                    //                    Text("Width: \(geo.size.width) Height: \(geo.size.height)")
                    //                }
                    
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                        .opacity(0.8)
                    
                    //              Client
                    VStack {
                        Image(systemName: "building.2")
                            .resizable()
                            .frame(width: 90, height: 70)
                            .foregroundStyle(Color.white)
                        
                        
                        Text("Client")
                            .foregroundStyle(Color.white)
                    }
                    .position(x: 100, y: 90)
                    
                    VStack {
                        Image(systemName: "building.2")
                            .resizable()
                            .frame(width: 90, height: 70)
                            .foregroundStyle(Color.white)
                        
                        Text("Client")
                            .foregroundStyle(Color.white)
                    }
                    .position(x: 1090, y: 90)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 100, y: 140))
                        path.addLine(to: CGPoint(x: 100, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 1090, y: 140))
                        path.addLine(to: CGPoint(x: 1090, y: 410))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    //              Truck
                    VStack {
                        Image(systemName: "truck.box.fill")
                            .resizable()
                            .frame(width: 100, height: 70)
                            .foregroundStyle(Color.white)
                    }
                    .position(x: 100, y: 250)
                    .onTapGesture {
                        goToTruckers = true
                    }
                    
                    VStack {
                        Image(systemName: "truck.box.fill")
                            .resizable()
                            .frame(width: 100, height: 70)
                            .foregroundStyle(Color.white)
                    }
                    .position(x: 1100, y: 250)
                    .onTapGesture {
                        goToTruckers = true
                    }
                    
                    
                    //              MARK: Receiving
                    VStack {
                        HStack {
                            Image("arrowg")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 210, y: 375)
                    
                    VStack {
                        HStack {
                            Text("Receiving")
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                        .background(Color.white.opacity(1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 100, y: 400)
                    .onTapGesture {
                        goToR_RMF = true
                        print("Hey")
                    }
                    
//                    VStack {
//                        HStack {
//                            Image("inv")
//                                .resizable()
//                                .frame(width: 50, height: 40)
//                        }
//                    }
//                    .position(x: 210, y: 425)
                    
                    VStack(spacing: 0) {
                        
                        // MARK: Header
                        HStack {
                            Text("Running")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 15, height: 15)
                                .opacity(blink ? 0.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        blink.toggle()
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 35)
                        .background(Color.blue)
                        
                        Divider()
                        
                        // MARK: Body
                        VStack(spacing: 8) {
                            
                            HStack {
                                Text("C/T")
                                Spacer()
                                Text("0.05 Days")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("W/T")
                                Spacer()
                                Text("2 Hours")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Uptime")
                                Spacer()
                                Text("12 Hours")
                                    .bold()
                            }
                            
                            Spacer()
                            
                            
                        }
                        .padding(10)
                        .font(.footnote)
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: "#6bd17c"), lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(radius: 5)
                    .position(x: 100, y: 560)
                    
                    //              MARK: Drying
                    VStack {
                        HStack {
                            Image("arrowg")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 430, y: 375)
                    
                    VStack {
                        HStack {
                            Text("Drying")
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 320, y: 400)
                    .onTapGesture {
                        goToDrying = true
                        print("Dry")
                    }
                    
                    VStack(spacing: 0) {
                        
                        // MARK: Header
                        HStack {
                            Text("Running")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 15, height: 15)
                                .opacity(blink2 ? 0.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        blink2.toggle()
                                    }
                                }
                            
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 35)
                        .background(Color.blue)
                        
                        Divider()
                        
                        // MARK: Body
                        VStack(spacing: 8) {
                            
                            HStack {
                                Text("C/T")
                                Spacer()
                                Text("5 Days")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("W/T")
                                Spacer()
                                Text("2 Hours")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Lead Time")
                                Spacer()
                                Text("24 Hours")
                                    .bold()
                            }
                            
                            Spacer()
                            
                            
                        }
                        .padding(10)
                        .font(.footnote)
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: "#6bd17c"), lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(radius: 5)
                    .position(x: 320, y: 560)
                    
                    
                    //              MARK: Shelling
                    VStack {
                        HStack {
                            Text("Shelling")
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                        .background(Color.white.opacity(1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 540, y: 400)
                    .onTapGesture {
                        goToShelling = true
                    }
                    
                    VStack {
                        HStack {
                            Image("arrowg")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 650, y: 375)
                    
                    VStack {
                        HStack {
                            Image("inv")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 650, y: 425)
                    .onTapGesture {
                        goToWarehouse = true
                    }
                    
                    VStack(spacing: 0) {
                        
                        // MARK: Header
                        HStack {
                            Text("Running")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Circle()
                                .fill(.yellow)
                                .frame(width: 15, height: 15)
                                .opacity(blink3 ? 0.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        blink3.toggle()
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 35)
                        .background(Color.blue)
                        
                        Divider()
                        
                        // MARK: Body
                        VStack(spacing: 8) {
                            
                            HStack {
                                Text("C/T")
                                Spacer()
                                Text("0.05 Days")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("W/T")
                                Spacer()
                                Text("2 Hours")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Uptime")
                                Spacer()
                                Text("12 Hours")
                                    .bold()
                            }
                            
                            Spacer()
                            
                            
                        }
                        .padding(10)
                        .font(.footnote)
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: "#6bd17c"), lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(radius: 5)
                    .position(x: 540, y: 560)
                    
                    //              MARK: Conditioning
                    
                    VStack {
                        HStack {
                            Text("Conditioning")
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                        .background(Color.white.opacity(1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 760, y: 400)
                    .onTapGesture {
                        goToCoditioning = true
                    }
                    
                    VStack {
                        HStack {
                            Image("arrowg")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 870, y: 375)
                    
                    VStack {
                        HStack {
                            Image("inv")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 870, y: 425)
                    .onTapGesture {
                        goToWarehouse = true
                    }
                    
                    VStack(spacing: 0) {
                        
                        // MARK: Header
                        HStack {
                            Text("Running")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Circle()
                                .fill(.red)
                                .frame(width: 15, height: 15)
                                .opacity(blink4 ? 0.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        blink4.toggle()
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 35)
                        .background(Color.blue)
                        
                        Divider()
                        
                        // MARK: Body
                        VStack(spacing: 8) {
                            
                            HStack {
                                Text("C/T")
                                Spacer()
                                Text("0.05 Days")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("W/T")
                                Spacer()
                                Text("2 Hours")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Uptime")
                                Spacer()
                                Text("12 Hours")
                                    .bold()
                            }
                            
                            Spacer()
                            
                            
                        }
                        .padding(10)
                        .font(.footnote)
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: "#6bd17c"), lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(radius: 5)
                    .position(x: 760, y: 560)
                    
                    //              MARK: Treat & Pack
                    
                    VStack {
                        HStack {
                            Text("Treat & Pack")
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 980, y: 400)
                    
                    
                    VStack {
                        HStack {
                            Image("inv")
                                .resizable()
                                .frame(width: 50, height: 40)
                        }
                    }
                    .position(x: 1090, y: 425)
                    .onTapGesture {
                        goToWarehouse = true
                    }
                    
                    VStack(spacing: 0) {
                        
                        // MARK: Header
                        HStack {
                            Text("Running")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Circle()
                                .fill(.red)
                                .frame(width: 15, height: 15)
                                .opacity(blink5 ? 0.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                        blink5.toggle()
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 35)
                        .background(Color.blue)
                        
                        Divider()
                        
                        // MARK: Body
                        VStack(spacing: 8) {
                            
                            HStack {
                                Text("C/T")
                                Spacer()
                                Text("0.05 Days")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("W/T")
                                Spacer()
                                Text("2 Hours")
                                    .bold()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Uptime")
                                Spacer()
                                Text("12 Hours")
                                    .bold()
                            }
                            
                            Spacer()
                            
                            
                        }
                        .padding(10)
                        .font(.footnote)
                        
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: "#6bd17c"), lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(radius: 5)
                    .position(x: 980, y: 560)
                    
                    ////              MARK: Truck2
                    //                VStack {
                    //                    Image("truck2")
                    //                        .resizable()
                    //                        .frame(width: 70, height: 130)
                    //                }
                    //                .position(x: 1090, y: 250)
                    //
                    ////              MARK: Client 2
                    //                VStack {
                    //                    Image("supplier")
                    //                        .resizable()
                    //                        .frame(width: 140, height: 110)
                    //                    Text("Client")
                    //                }
                    //                .position(x: 1090, y: 90)
                    
                    
                    //              MARK: System
                    
                    
                    
                    Path { path in
                        path.move(to: CGPoint(x: 540, y: 150))
                        path.addLine(to: CGPoint(x: 110, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10, 5],
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 540, y: 150))
                        path.addLine(to: CGPoint(x: 330, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10, 5],
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 540, y: 150))
                        path.addLine(to: CGPoint(x: 540, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10, 5],
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 540, y: 150))
                        path.addLine(to: CGPoint(x: 770, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10, 5],
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 540, y: 150))
                        path.addLine(to: CGPoint(x: 980, y: 350))
                    }
                    .stroke(
                        Color(hex: "#6bd17c"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10, 5],
                            dashPhase: phase   // 10 = line length, 5 = gap
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            phase = -14.5
                        }
                    }
                    
                    VStack {
                        
                        
                        HStack {
                            VStack {
//                                Image("adv")
//                                    .resizable()
//                                    .frame(width: 80, height: 50)
                                
                                Text("Requirement")
                                Text("Volume: 8000MT")
                                    .font(.footnote)
                                    .bold()
                            }
                        }
                        .frame(maxWidth: 200, maxHeight: 150)
                        .background(Color.white.opacity(1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6bd17c"), lineWidth: 5)
                        )
                    }
                    .position(x: 540, y: 100)
                    
                    
                    //              MARK: Timeline
                    
                    VStack {
                        HStack {
                            Text("0.1 Days")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                       
                    }
                    .position(x: 100, y: 700)
                    
                    VStack {
                        HStack {
                            Text("5 Days")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                       
                    }
                    .position(x: 330, y: 700)
                    
                    VStack {
                        HStack {
                            Text("0.1 Days")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                       
                    }
                    .position(x: 550, y: 700)
                    
                    VStack {
                        HStack {
                            Text("0.1 Days")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                       
                    }
                    .position(x: 770, y: 700)
                    
                    VStack {
                        HStack {
                            Text("0.1 Days")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 150, maxHeight: 100)
                       
                    }
                    .position(x: 990, y: 700)
                    
                    VStack {
                        HStack {
                            Text("Lead Time: 5.4 Days")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .frame(maxWidth: 250, maxHeight: 100)
                       
                    }
                    .position(x: 550, y: 760)
                    
                    
                    VStack {
                        HStack {
                            Image("durations")
                                .resizable()
                                .frame(width: 1190, height: 50)
                        }
                    }
                    .position(x: 600, y: 705)
                    
                    
                }
                .background(Color.black.opacity(1))
            }
            .navigationDestination(isPresented: $goToR_RMF){
                P_Home()
            }
            .navigationDestination(isPresented: $goToDrying) {
                DR_Nav()
            }
            .navigationDestination(isPresented: $goToShelling) {
                SHLW_Nav()
            }
            .navigationDestination(isPresented: $goToCoditioning) {
                CNDW_Nav()
            }
            .navigationDestination(isPresented: $goToWarehouse) {
                WH_Home()
            }
            .navigationDestination(isPresented: $goToTruckers) {
                TR_Home()
            }
        }
        
    }
}

#Preview {
    Dashboard()
}
