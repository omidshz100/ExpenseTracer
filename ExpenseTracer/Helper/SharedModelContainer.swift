//
//  SharedModelContainer.swift
//  ExpenseTracer
//

import Foundation
import SwiftData

enum SharedModelContainer {
    static let appGroupID = "group.com.app.ExpenseTracer"
    static let storeName = "ExpenseTracer.store"

    static let shared: ModelContainer = {
        do {
            return try makeContainer()
        } catch {
            fatalError("Unable to create the expense store: \(error)")
        }
    }()

    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([TransactionModel.self])
        let configuration = ModelConfiguration(schema: schema, url: storeURL())
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    /// App and widget must open this same file. Without an App Group the app keeps the local store so it still launches.
    static func storeURL() -> URL {
        let fileManager = FileManager.default
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return legacyStoreURL()
        }

        let sharedURL = groupURL.appendingPathComponent(storeName)
        migrateLegacyStoreIfNeeded(to: sharedURL)
        return sharedURL
    }

    private static func legacyStoreURL() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL.applicationSupportDirectory
        return appSupport.appendingPathComponent("default.store")
    }

    /// Copies the pre-App-Group SwiftData files once, before either process opens the shared store.
    private static func migrateLegacyStoreIfNeeded(to sharedURL: URL) {
        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: sharedURL.path) else { return }

        let legacyURL = legacyStoreURL()
        guard fileManager.fileExists(atPath: legacyURL.path) else { return }

        let directory = sharedURL.deletingLastPathComponent()
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        for suffix in ["", "-shm", "-wal"] {
            let source = URL(fileURLWithPath: legacyURL.path + suffix)
            let destination = URL(fileURLWithPath: sharedURL.path + suffix)
            guard fileManager.fileExists(atPath: source.path) else { continue }
            try? fileManager.copyItem(at: source, to: destination)
        }
    }
}
