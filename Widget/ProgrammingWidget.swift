//
//  ProgrammingWidget.swift
//  ProgrammingWidget
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 22/11/2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ProgrammingWidgetEntryView : View {
    // MARK: Properties
    var entry: Provider.Entry
    let suggested = UserDefaults(suiteName: "group.com.example.ProgrammingTutorials.ProgrammingWidget")?.value(forKey: "Suggested") as? String ?? "C#"
    
    var imageName: String {
        switch suggested {
        case "C++": return "cpp"
        case "C#": return "csharp"
        case "Swift": return "swift"
        case "PHP": return "php"
        case "JavaScript": return "js"
        default: return "csharp"
        }
    }

    var body: some View {
        ZStack {
            // Setup Background
            Color.black.opacity(0.9)
            
            // Widget
            VStack(alignment: .center, spacing: 10) {
                // Image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .blue, radius: 3)
                // Text
                Text("Suggested language")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
            .padding()
        }
        // Border
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 5)
                .shadow(color: .white, radius: 3)
        )
    }
}

@main
struct ProgrammingWidget: Widget {
    let kind: String = "ProgrammingWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ProgrammingWidgetEntryView(entry: entry)
        }
    }
}

struct ProgrammingWidget_Previews: PreviewProvider {
    static var previews: some View {
        ProgrammingWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
