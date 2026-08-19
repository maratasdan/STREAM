//
//  DR_CurrentPanelsDetails.swift
//  STREAM
//
//  Created by danxd on 7/26/26.
//

import SwiftUI
import SwiftData

struct DryingHeaderUpload: Codable {
    var dhid: String
    var rhid: String
    var initial_mc: String
    var drying_start: String
    var est_drying_end: String
    var reversal: String
    var blower: String
    var bin_id: String
    var hybrid: String
    var statis: String
}

struct DryingDataRows: Codable {
    var dmid: String
    var dhid: String
    var noh: String
    var date: String
    var time: String
    var upper: String
    var lower: String
    var boiler: String
    var mc: String
    var status: String
    var remarks: String?
}

struct DryingAIData: Codable, Identifiable {
    var id: String { rhid }
    var rhid: String
    var crop: String
    var hours: Double
    var days: Double
    var start_date: String
    var estimated_end: String
    var initial_mc: Double
    var avg_upper: Double
    var avg_lower: Double
    var max_upper: Double
    var min_upper: Double
    var max_lower: Double
    var min_lower: Double
    var monitoring_count: Int
}

struct DR_CurrentPanelsDetails: View {
    
    let dhid: String
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var dryingrows: [tbl_drmonitoring_rows]
    @Query private var dryingheader: [tbl_drying_header]
    
    @State private var dryingaidata: [DryingAIData] = []
    
    @State private var openAddModal: Bool = false
    @State private var showAIPrediction: Bool = false
    
    @State private var datetime = ""
    @State private var noh: String = ""
    @State private var upper: String = ""
    @State private var lower: String = ""
    @State private var mc: String = ""
    @State private var remarks: String = ""
    
    @State private var remarksRev: String = "REVERSAL"
    @State private var remarksDS: String = "DOWNTIME START"
    @State private var remarksDE: String = "DOWNTIME END"
    
    @State private var errmsg: String = ""
    @State private var showProgress = false
    @State private var currentDate = Date()
    
    @State private var openReversalAlert: Bool = false
    @State private var openDowntimeAlert: Bool = false
    @State private var openDowntimeAlertEnd: Bool = false
    @State private var openLineGraph: Bool = false
    
    @State private var searchText = ""
    
    @State private var breathe = false
    
    private var filteredRow: [tbl_drmonitoring_rows] {
        dryingrows.filter { $0.dhid == dhid }
            .reversed()
            .sorted { $0.date > $1.date }
    }
    
    var filteredRowSearch: [tbl_drmonitoring_rows] {
        if searchText.isEmpty {
            return filteredRow
        }
        
        return filteredRow.filter {
            $0.date.localizedCaseInsensitiveContains(searchText) ||
            $0.noh.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredRowUpload: [tbl_drmonitoring_rows] {
        dryingrows.filter { $0.dhid == dhid }
            .sorted { $0.date > $1.date }
    }
    
    private var filterheader: [tbl_drying_header] {
        dryingheader.filter { $0.dhid == dhid }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        List {
                            Section {
                                HStack {
                                    
                                    if filterheader.first?.statis == "2" {
                                        VStack(alignment: .center) {
                                            TimelineView(.periodic(from: .now, by: 1)) { _ in
                                                Text("DOWNTIME")
                                                    .foregroundStyle(Color.red)
                                                    .font(.system(size: 35))
                                                    .bold()
                                                    .monospacedDigit()
                                            }
                                            .listRowBackground(Color.red)
                                        }
                                        .frame(maxWidth: .infinity)
                                    } else {
                                        VStack(alignment: .center) {
                                            TimelineView(.periodic(from: .now, by: 1)) { _ in
                                                Text(countdown(from: filteredRow.first?.date ?? "NA"))
                                                    .font(.system(size: 40))
                                                    .bold()
                                                    .monospacedDigit()
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    
                                    ZStack {
                                        if filterheader.first?.blower == "0" {
                                            Image(systemName: "arrow.up")
                                                .foregroundStyle(Color.blue)
                                                .font(.title)
                                        } else {
                                            Image(systemName: "arrow.down")
                                                .foregroundStyle(Color.blue)
                                                .font(.title)
                                        }
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(30)
                                    }
                                    
                                }
                            }
                            Section {
                                HStack {
                                    HStack {
                                        ZStack {
                                            Image(systemName: "archivebox.fill")
                                                .foregroundStyle(Color.blue)
                                            Rectangle()
                                                .foregroundStyle(Color.blue.opacity(0.15))
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(30)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("\(filterheader.first?.bin_id ?? "32.4")")
                                                .bold()
                                            Text("Bin")
                                                .font(.footnote)
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }
                                }
                                HStack {
                                    HStack {
                                        ZStack {
                                            Image(systemName: "drop.fill")
                                                .foregroundStyle(Color.blue)
                                            Rectangle()
                                                .foregroundStyle(Color.blue.opacity(0.15))
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(30)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("\(filterheader.first?.initial_mc ?? "32.4")")
                                                .bold()
                                            Text("Initial MC")
                                                .font(.footnote)
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }
                                }
                                HStack {
                                    ZStack {
                                        Image(systemName: "calendar.badge.clock")
                                            .foregroundStyle(Color.blue)
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(30)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(formatDate(filterheader.first?.drying_start ?? formatDate("2026-07-24 13:22:50")))")
                                            .bold()
                                        Text("Drying Start")
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                                HStack {
                                    ZStack {
                                        Image(systemName: "calendar.badge.checkmark")
                                            .foregroundStyle(Color.blue)
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(30)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(formatDate(filterheader.first?.est_drying_end ?? formatDate("2026-07-24 13:22:50")))")
                                            .bold()
                                        Text("Est. Drying End")
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                                HStack {
                                    ZStack {
                                        Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                                            .foregroundStyle(Color.blue)
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(30)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(formatDate(filterheader.first?.reversal ?? "In 43 Hours"))")
                                            .bold()
                                        Text("Reversal")
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                                HStack {
                                    ZStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundStyle(Color.blue)
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(30)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(formatDate(filterheader.first?.hybrid ?? "R2"))")
                                            .bold()
                                        Text("Hybrid")
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                                HStack {
                                    ZStack {
                                        Image(systemName: "timer")
                                            .foregroundStyle(Color.blue)
                                        Rectangle()
                                            .foregroundStyle(Color.blue.opacity(0.15))
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(30)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(numberOfHours(from: filteredRowUpload.last?.date ?? ""))
                                            .bold()
                                        Text("Number of Hours")
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                    }
                                }
                            }
                        }
                        .listStyle(.sidebar)
                    }
                    .frame(width: 350)
                    
                    VStack(alignment: .leading) {
                        Table(filteredRowSearch) {
                            TableColumn("NOH", value: \.noh)
                            TableColumn("Date/Time") { item in
                                Text(formatDate(item.date))
                            }
                                .width(200)
                            TableColumn("Top", value: \.upper)
                            TableColumn("Bot", value: \.lower)
                            TableColumn("MC", value: \.mc)
                            TableColumn("Remarks") { item in
                                
                                if item.remarks == "REVERSAL" {
                                    Text(item.remarks ?? "")
                                        .padding(3)
                                        .background(Color.green.opacity(0.15))
                                        .cornerRadius(5)
                                } else if item.remarks == "DOWNTIME START" {
                                    Text(item.remarks ?? "")
                                        .padding(3)
                                        .background(Color.red.opacity(0.15))
                                        .cornerRadius(5)
                                } else if item.remarks == "DOWNTIME END" {
                                    Text(item.remarks ?? "")
                                        .padding(3)
                                        .background(Color.red.opacity(0.15))
                                        .cornerRadius(5)
                                } else if item.remarks == "Topup" {
                                    Text(item.remarks?.uppercased() ?? "")
                                        .padding(3)
                                        .background(Color.yellow.opacity(0.15))
                                        .cornerRadius(5)
                                } else {
                                    Text(item.remarks ?? "")
                                        .padding(3)
                                        .background(Color.clear)
                                        .cornerRadius(5)
                                }
                                   
                            }
                            .width(220)
                        }
                        .searchable(text: $searchText, prompt: "Search Date or NOH")
//                        MARK: Add Item
                        .sheet(isPresented: $openAddModal) {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text("Add Monitoring Record")
                                    .font(.title2)
                                    .bold()
                                Text((errmsg))
                                    .font(.footnote)
                                    .foregroundStyle(Color.red)
                                
                                GroupBox("Information") {
                                    VStack(spacing: 15) {
                                        
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                                .foregroundStyle(.blue)
                                            
                                            TextField("Date & Time", text: $datetime)
                                                .disabled(true)
                                        }
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onAppear {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            datetime = formatter.string(from: Date())
                                        }
                                        
                                        HStack(spacing: 15) {
                                            
                                            VStack(alignment: .leading) {
                                                Text("Top")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $upper)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Bottom")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $lower)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Moisture Content (%)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("0.00", text: $mc)
                                                .textFieldStyle(.roundedBorder)
                                                .keyboardType(.decimalPad)
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Remarks")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("Remarks Here...", text: $remarks)
                                                .textFieldStyle(.roundedBorder)
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                    }
                                }
                                
                                Button {
                                    if upper.isEmpty || lower.isEmpty  {
                                        errmsg = "Please fill all the fields"
                                    } else {
                                        addItemRow(
                                            dhid: dhid,
                                            datetime: datetime,
                                            noh: noh,
                                            top: upper,
                                            bot: lower,
                                            mc: mc,
                                            remarksx: remarks
                                        )
                                    }
                                } label: {
                                    Label("Add Monitoring", systemImage: "plus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.glassProminent)

                            }
                            .padding(20)
                            .presentationDetents([.large])
                        }
//                       MARK: Reversal Alert
                        .sheet(isPresented: $openReversalAlert) {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text("Reversal Record")
                                    .font(.title2)
                                    .bold()
                                Text((errmsg))
                                    .font(.footnote)
                                    .foregroundStyle(Color.red)
                                
                                GroupBox("Information") {
                                    VStack(spacing: 15) {
                                        
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                                .foregroundStyle(.blue)
                                            
                                            TextField("Date & Time", text: $datetime)
                                                .disabled(true)
                                        }
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onAppear {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            datetime = formatter.string(from: Date())
                                        }
                                        
                                        HStack(spacing: 15) {
                                            
                                            VStack(alignment: .leading) {
                                                Text("Top")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $upper)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Bottom")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $lower)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Moisture Content (%)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("0.00", text: $mc)
                                                .textFieldStyle(.roundedBorder)
                                                .keyboardType(.decimalPad)
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Remarks")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("Remarks Here...", text: $remarksRev)
                                                .disabled(true)
                                                .background(Color.gray.opacity(0.1))
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                    }
                                }
                                
                                Button {
                                    if upper.isEmpty || lower.isEmpty  {
                                        errmsg = "Please fill all the fields"
                                    } else {
                                        addReversal(dhid: dhid,
                                            datetime: datetime,
                                            noh: noh,
                                            top: upper,
                                            bot: lower,
                                            mc: mc,
                                            remarksx: remarksRev)
                                    }
                                } label: {
                                    Label("Add Monitoring", systemImage: "plus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.glassProminent)

                            }
                            .padding(20)
                            .presentationDetents([.large])
                        }
//                       MARK: Downtime Start
                        .sheet(isPresented: $openDowntimeAlert) {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text("Downtime Record")
                                    .font(.title2)
                                    .bold()
                                Text((errmsg))
                                    .font(.footnote)
                                    .foregroundStyle(Color.red)
                                
                                GroupBox("Information") {
                                    VStack(spacing: 15) {
                                        
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                                .foregroundStyle(.blue)
                                            
                                            TextField("Date & Time", text: $datetime)
                                                .disabled(true)
                                        }
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onAppear {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            datetime = formatter.string(from: Date())
                                        }
                                        
                                        HStack(spacing: 15) {
                                            
                                            VStack(alignment: .leading) {
                                                Text("Top")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $upper)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Bottom")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $lower)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Moisture Content (%)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("0.00", text: $mc)
                                                .textFieldStyle(.roundedBorder)
                                                .keyboardType(.decimalPad)
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Remarks")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("Remarks Here...", text: $remarksDS)
                                                .disabled(true)
                                                .background(Color.gray.opacity(0.1))
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                    }
                                }
                                
                                Button {
                                    if upper.isEmpty || lower.isEmpty  {
                                        errmsg = "Please fill all the fields"
                                    } else {
                                        downtimeStart(dhid: dhid,
                                            datetime: datetime,
                                            noh: noh,
                                            top: upper,
                                            bot: lower,
                                            mc: mc,
                                            remarksx: remarksDS)
                                        openDowntimeAlert = false
                                    }
                                } label: {
                                    Label("Add Monitoring", systemImage: "plus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.glassProminent)

                            }
                            .padding(20)
                            .presentationDetents([.large])
                        }
//                       MARK: Downtime End
                        .sheet(isPresented: $openDowntimeAlertEnd) {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text("Downtime Record")
                                    .font(.title2)
                                    .bold()
                                Text((errmsg))
                                    .font(.footnote)
                                    .foregroundStyle(Color.red)
                                
                                GroupBox("Information") {
                                    VStack(spacing: 15) {
                                        
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                                .foregroundStyle(.blue)
                                            
                                            TextField("Date & Time", text: $datetime)
                                                .disabled(true)
                                        }
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onAppear {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            datetime = formatter.string(from: Date())
                                        }
                                        
                                        HStack(spacing: 15) {
                                            
                                            VStack(alignment: .leading) {
                                                Text("Top")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $upper)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Bottom")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                
                                                TextField("0", text: $lower)
                                                    .textFieldStyle(.roundedBorder)
                                                    .keyboardType(.decimalPad)
                                                    .onTapGesture {
                                                        errmsg = ""
                                                    }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Moisture Content (%)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("0.00", text: $mc)
                                                .textFieldStyle(.roundedBorder)
                                                .keyboardType(.decimalPad)
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Remarks")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            TextField("Remarks Here...", text: $remarksDE)
                                                .disabled(true)
                                                .background(Color.gray.opacity(0.1))
                                                .onTapGesture {
                                                    errmsg = ""
                                                }
                                        }
                                    }
                                }
                                
                                Button {
                                    if upper.isEmpty || lower.isEmpty  {
                                        errmsg = "Please fill all the fields"
                                    } else {
                                        downtimeStartEnd(dhid: dhid,
                                            datetime: datetime,
                                            noh: noh,
                                            top: upper,
                                            bot: lower,
                                            mc: mc,
                                            remarksx: remarksDE)
                                        openDowntimeAlertEnd = false
                                    }
                                } label: {
                                    Label("Add Monitoring", systemImage: "plus.circle.fill")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.glassProminent)

                            }
                            .padding(20)
                            .presentationDetents([.large])
                        }
                    }
                }
            }
            .sheet(isPresented: $showProgress) {
                VStack(spacing: 25) {

                    ProgressView()
                        .controlSize(.extraLarge)

                    Text("Uploading Data...")
                        .font(.title2.bold())

                }
                .frame(width: 350, height: 220)
                .presentationDetents([.height(220)])
            }
            
            .sheet(isPresented: $showAIPrediction) {
                NavigationStack {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color.indigo.opacity(0.10))
                            .ignoresSafeArea()
                        
                        
                        
                        
                        VStack(alignment: .leading,spacing: 25) {
                            
                            List {
                                Section {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("SSC AI")
                                                .font(.title)
                                                .bold()
                                                .foregroundStyle(Color.indigo)
                                            ZStack {
                                                Rectangle()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundStyle(Color.white)
                                                    .cornerRadius(100)
                                                Image(systemName: "sparkles")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(Color.indigo)
                                            }
                                            
                                            Spacer()
                                        }
                                        Text("Drying Predictions (Beta)")
                                            .foregroundStyle(Color.indigo.opacity(0.70))
                                    }
                                }.listRowBackground(Color.clear)
                                
                                Section {
                                    
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width: 45, height: 45)
                                                    .foregroundStyle(Color.indigo.opacity(0.15))
                                                    .cornerRadius(100)
                                                Image(systemName: "clock.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(Color.indigo)
                                            }
                                            VStack(alignment: .leading) {
                                                Text("\(dryingaidata.first?.hours ?? 0, format: .number)")
                                                    .bold()
                                                Text("Drying Hours")
                                                    .foregroundStyle(Color.indigo.opacity(0.70))
                                            }
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width: 45, height: 45)
                                                    .foregroundStyle(Color.indigo.opacity(0.15))
                                                    .cornerRadius(100)
                                                Image(systemName: "calendar.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(Color.indigo)
                                            }
                                            VStack(alignment: .leading) {
                                                Text("\(dryingaidata.first?.estimated_end ?? "")")
                                                    .bold()
                                                Text("Estimated End")
                                                    .foregroundStyle(Color.indigo.opacity(0.70))
                                            }
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width: 45, height: 45)
                                                    .foregroundStyle(Color.indigo.opacity(0.15))
                                                    .cornerRadius(100)
                                                Image(systemName: "sun.min")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(Color.indigo)
                                            }
                                            VStack(alignment: .leading) {
                                                Text("\(dryingaidata.first?.days ?? 0, format: .number) Days")
                                                    .bold()
                                                Text("Drying end in")
                                                    .foregroundStyle(Color.indigo.opacity(0.70))
                                            }
                                        }
                                    }
                                }
                                .listRowBackground(Color.white)
                                
                                Section {
                                    NavigationLink(destination: DR_SSCAI_About()) {
                                        Label("About this", systemImage: "questionmark.circle.fill")
                                            .foregroundStyle(Color.indigo)
                                    }
                                }
                                .listRowBackground(Color.white)
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.top, 50)
                        .padding(20)
                        .presentationDetents([.height(620)])
                    }
                }
            }
            .onAppear() {
                getAIData(rhid: filterheader.first?.rhid ?? "0")
            }
        }
        
        
//      MARK: Navigation
        .navigationDestination(isPresented: $openLineGraph) {
            DR_LineGraph(dhid: dhid)
        }
//      MARK: Search Box
        .searchable(text: $searchText, prompt: "Search Date or NOH")
        
//      MARK: ToolBars
        
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showProgress = true
                    uploadDataHeader()
                }) {
                    HStack {
                        Image(systemName: "icloud.and.arrow.up.fill")
                            .foregroundStyle(Color.green)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: DR_ViewRMF(rhid: "\(filterheader.first?.rhid ?? "NA")")) {
                    Label("RMF", systemImage: "list.clipboard.fill")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Menu {
                    Button(action: {
                        openAddModal = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .tint(Color.blue)
                            Text("Add Data")
                        }
                    }
                    Button(action: {
                        openReversalAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.trianglehead.2.clockwise")
                                .tint(Color.green)
                            Text("Reversal")
                        }
                    }
                    Button(action: {
                        
                        if filterheader.first?.statis == "0" || filterheader.first?.statis == "1" {
                            openDowntimeAlert = true
                        } else if filterheader.first?.statis == "2" {
                            openDowntimeAlertEnd = true
                        }
                        
                    }) {
                        
                        if filterheader.first?.statis == "0" || filterheader.first?.statis == "1" {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                    .tint(Color.red)
                                Text("Downtime Start")
                            }
                        } else if filterheader.first?.statis == "2" {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                    .tint(Color.red)
                                Text("Downtime End")
                            }
                        }
                        
                        
                    }
                    
                    Button(action: {
                        openLineGraph = true
                    }) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                                .tint(Color.orange)
                            Text("Tempt Stats")
                        }
                    }
                    
                    Button(action: {
                        getAIData(rhid: filterheader.first?.rhid ?? "0")
                        showAIPrediction = true
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                                .tint(Color.indigo)
                            Text("AI Predictions")
                        }
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
//  MARK: Function for Downtime End
    func downtimeStartEnd(dhid: String, datetime: String, noh: String, top: String, bot: String, mc: String, remarksx: String) {
        
        let item = FetchDescriptor<tbl_drying_header> (
            predicate: #Predicate {
                $0.dhid == dhid
            }
        )
        
        do {
            if let itemheader = try context.fetch(item).first {
                itemheader.statis = "1"
                
                try context.save()
                print("Downtime Saved!")
            }
        } catch {
            print("Error saving Downtime")
        }
        
        let itemrows = tbl_drmonitoring_rows(
            dmid: UUID().uuidString,
            dhid: dhid,
            noh: numberOfHours(from: filteredRowUpload.last?.date ?? ""),
            date: datetime,
            time: datetime,
            upper: top,
            lower: bot,
            boiler: "0",
            mc: mc,
            status: "1",
            remarks: remarksx)
        
        do {
            context.insert(itemrows)
            try context.save()
            print("Success Saving Row for Downtime End")
        } catch {
            print("Error Downtime End Row")
        }
        
    }
    
//  MARK: Function for Downtime Start
    func downtimeStart(dhid: String, datetime: String, noh: String, top: String, bot: String, mc: String, remarksx: String) {
        
        let item = FetchDescriptor<tbl_drying_header> (
            predicate: #Predicate {
                $0.dhid == dhid
            }
        )
        
        do {
            if let itemheader = try context.fetch(item).first {
                itemheader.statis = "2"
                
                try context.save()
                print("Downtime Saved!")
            }
        } catch {
            print("Error saving Downtime")
        }
        
        let itemrows = tbl_drmonitoring_rows(
            dmid: UUID().uuidString,
            dhid: dhid,
            noh: numberOfHours(from: filteredRowUpload.last?.date ?? ""),
            date: datetime,
            time: datetime,
            upper: top,
            lower: bot,
            boiler: "0",
            mc: mc,
            status: "1",
            remarks: remarksx)
        
        do {
            context.insert(itemrows)
            try context.save()
            print("Success Saving Row for Downtime")
        } catch {
            print("Error Downtime Row")
        }
        
    }

    func addReversal(dhid: String, datetime: String, noh: String, top: String, bot: String, mc: String, remarksx: String) {
        
        //Header
        let descriptor = FetchDescriptor<tbl_drying_header>(
            predicate: #Predicate {
                $0.dhid == dhid
            }
        )
        
        do {
            if let item = try context.fetch(descriptor).first {
                item.blower = "1"
                
                try context.save()
                print("Blower Updated!")
            }
        } catch {
            print("Error saving header!")
        }
        
        //Add Row
        
        let rowitem = tbl_drmonitoring_rows(
            dmid: UUID().uuidString,
            dhid: dhid,
            noh: numberOfHours(from: filteredRowUpload.last?.date ?? ""),
            date: datetime,
            time: datetime,
            upper: top,
            lower: bot,
            boiler: "0",
            mc: mc,
            status: "1",
            remarks: remarksx)
        
        do {
            
            context.insert(rowitem)
            try context.save()
            print("Row Saved!")
            
        } catch {
            print("Error saving row!")
        }
        
    }
    
    
    func numberOfHours(from dateString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let startDate = formatter.date(from: dateString) else {
            return "--:--:--"
        }
        
        let elapsed = Int(Date().timeIntervalSince(startDate))

        if elapsed < 0 {
            return "00:00:00"
        }
        
        let hours = elapsed / 3600
        let minutes = (elapsed % 3600) / 60
        let seconds = elapsed % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func countdown(from dateString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let savedDate = formatter.date(from: dateString) else {
            return "--:--:--"
        }

        let expiryDate = savedDate.addingTimeInterval(3600)

        let remaining = Int(expiryDate.timeIntervalSince(Date()))

        if remaining <= 0 {
            return "Timers Up!"
        }

        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formatDate(_ dateString: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = input.date(from: dateString) else {
            return dateString
        }

        let output = DateFormatter()
        output.dateFormat = "MMM d, yyyy • h:mm a"

        return output.string(from: date)
    }
    
    func addItemRow(dhid: String, datetime: String, noh: String, top: String, bot: String, mc: String, remarksx: String) {
        
        
        let item = tbl_drmonitoring_rows(
            dmid: UUID().uuidString,
            dhid: dhid,
            noh: numberOfHours(from: filteredRowUpload.last?.date ?? ""),
            date: datetime,
            time: datetime,
            upper: top,
            lower: lower,
            boiler: "0",
            mc: mc,
            status: "1",
            remarks: remarksx
            )
        
        do {
            context.insert(item)
            try context.save()
            openAddModal = false
            print("Saved!")
        } catch {
            print("Error")
        }
        
    }
    
    func uploadDataHeader() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/upload_data_from_appdr.php?type=1") else { return }
        
        let header = filterheader.map {
            DryingHeader(dhid: $0.dhid,
                         rhid: $0.rhid,
                         bin_id: $0.bin_id,
                         initial_mc: $0.initial_mc,
                         drying_start: $0.drying_start,
                         date: $0.drying_start,
                         device_owner: "",
                         device_model: "",
                         deivice_id: "",
                         est_drying_end: "",
                         reversal: "",
                         blower: $0.blower,
                         hybrid_code: "",
                         statis: $0.statis,
                         topup_new_mc: "",
                         status: ""
                        )
        }

        do {
            let jsonData = try JSONEncoder().encode(header)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in

                if let error = error {
                    print(error)
                    return
                }

                if let data = data {
                    print(String(data: data, encoding: .utf8) ?? "")
                    dryerRows(dhid: dhid)
                }

            }.resume()

        } catch {
            print(error)
        }
    }
    
    func dryerRows(dhid: String) {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/upload_data_from_appdr.php?type=2&dhid=\(dhid)") else { return }
        
        let rows = filteredRow.map {
            DryingDataRows(
                dmid: "0",
                dhid: $0.dhid,
                noh: $0.noh,
                date: $0.date,
                time: $0.time,
                upper: $0.upper,
                lower: $0.lower,
                boiler: $0.boiler,
                mc: $0.mc,
                status: $0.status,
                remarks: $0.remarks ?? "NA")
        }
        
        do {
            let jsonData = try JSONEncoder().encode(rows)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in

                if let error = error {
                    print(error)
                    return
                }

                if let data = data {
                    if String(data: data, encoding: .utf8) ?? "" == "Done Rows" {
                        deletelocaldata()
                    }
                    print(String(data: data, encoding: .utf8) ?? "")
                }

            }.resume()

        } catch {
            print(error)
        }
        
    }
    
    func deletelocaldata() {
        let descriptor = FetchDescriptor<tbl_drying_header>(
            predicate: #Predicate { $0.dhid == dhid }
        )
        
        let descriptorrows = FetchDescriptor<tbl_drmonitoring_rows>(
            predicate: #Predicate { $0.dhid == dhid }
        )
        
        do {
            let result = try context.fetch(descriptor)

            if let header = result.first {
                context.delete(header)
                
                let resultrows = try context.fetch(descriptorrows)
                
                for row in resultrows {
                    context.delete(row)
                }
                
                try context.save()
                
                print("DB Deleted")
                showProgress = false
                
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        } catch {
            print("Error Deleting Local Data")
        }
    }
    
    func getAIData(rhid: String) {

        guard let url = URL(string: "https://stellarseedscorp.org/system/AI/DR/predict-json.php?rhid=\(rhid)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryingAIData].self, from: data)

                DispatchQueue.main.async {
                    self.dryingaidata = result
                    print(result)
                    print(dryingaidata.first?.days ?? 0)
                }

            } catch {
                print(error)
                print(String(data: data, encoding: .utf8) ?? "")
            }

        }.resume()
    }
}

#Preview {
    DR_CurrentPanelsDetails(dhid: "")
}
