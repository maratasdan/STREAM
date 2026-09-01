//
//  DR_LineGraph.swift
//  STREAM
//
//  Created by Danxd on 7/30/26.
//

import SwiftUI
import Charts
import SwiftData

struct TemperaturePoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct TemperatureSeries: Identifiable {
    let id: String
    let type: String
    let points: [TemperaturePoint]
}

struct DR_LineGraph: View {

    let dhid: String

    @Query private var drmonitoring: [tbl_drmonitoring_rows]

    @State private var selectedDate: Date?

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    private let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM dd, yyyy hh:mm a"
        return f
    }()

    var filtereddrmonitoring: [tbl_drmonitoring_rows] {
        drmonitoring
            .filter {
                $0.dhid == dhid
            }
            .sorted {
                $0.date < $1.date
            }
    }

    var chartData: [TemperatureSeries] {

        [
            TemperatureSeries(
                id: "top",
                type: "Top",
                points: filtereddrmonitoring.map {

                    TemperaturePoint(
                        date: formatter.date(from: $0.date) ?? Date(),
                        value: Double($0.upper) ?? 0
                    )

                }
            ),

            TemperatureSeries(
                id: "bottom",
                type: "Bottom",
                points: filtereddrmonitoring.map {

                    TemperaturePoint(
                        date: formatter.date(from: $0.date) ?? Date(),
                        value: Double($0.lower) ?? 0
                    )

                }
            )
        ]

    }

    var selectedMonitoring: tbl_drmonitoring_rows? {

        guard let selectedDate else { return nil }

        return filtereddrmonitoring.min { lhs, rhs in

            let lhsDate = formatter.date(from: lhs.date) ?? .distantPast
            let rhsDate = formatter.date(from: rhs.date) ?? .distantPast

            return abs(lhsDate.timeIntervalSince(selectedDate))
            <
            abs(rhsDate.timeIntervalSince(selectedDate))

        }

    }

    var body: some View {
        VStack(spacing: 15) {

            if let item = selectedMonitoring {
                VStack(alignment: .leading, spacing: 8) {
                    Text(
                        displayFormatter.string(
                            from: formatter.date(from: item.date) ?? Date()
                        )
                    )
                    .font(.headline)

                    Divider()

                    HStack {
                        Label("Top", systemImage: "thermometer.high")
                            .foregroundStyle(.red)

                        Spacer()

                        Text("\(item.upper)°C")
                            .bold()
                    }

                    HStack {
                        Label("Bottom", systemImage: "thermometer.low")
                            .foregroundStyle(.blue)

                        Spacer()

                        Text("\(item.lower)°C")
                            .bold()
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
            }

            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    Chart(chartData) { series in
                        ForEach(series.points) { point in
                            LineMark(
                                x: .value("Time", point.date),
                                y: .value("Temperature", point.value)
                            )
                            .interpolationMethod(.linear)

                            PointMark(
                                x: .value("Time", point.date),
                                y: .value("Temperature", point.value)
                            )
                        }
                        .foregroundStyle(by: .value("Series", series.type))
                        .symbol(by: .value("Series", series.type))

                        if let selectedDate {
                            RuleMark(
                                x: .value("Selected", selectedDate)
                            )
                            .foregroundStyle(.gray.opacity(0.5))
                        }
                    }
                    .chartXSelection(value: $selectedDate)
                    .frame(
                        width: max(
                            CGFloat(filtereddrmonitoring.count) * 70,
                            geometry.size.width
                        )
                    )
                    .padding()
                }
            }
        }
    }
}

#Preview {
    DR_LineGraph(dhid: "")
}
