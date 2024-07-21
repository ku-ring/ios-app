//
//  SubscriptionWidgetProvider.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import WidgetKit

final class SubscriptionWidgetProvider: TimelineProvider {
    typealias Entry = SubscriptionWidgetViewModel
    
    func placeholder(in context: Context) -> Entry {
        Entry.defaultEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        self.cofigureEntry { entry in
            guard let entry else {
                completion(Entry.defaultEntry())
                return
            }
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        self.cofigureEntry { entry in
            guard let entry else { return }
            completion(Timeline(entries: [entry], policy: .never))
        }
    }
    
    private func cofigureEntry(completion: @escaping (Entry?) -> Void) {
        let entry = Entry()
        completion(entry)
    }
}
