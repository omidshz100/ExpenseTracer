//
//  AppLanguage.swift
//  ExpenseTracer
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case italian = "it"
    case persian = "fa"

    static let storageKey = "appLanguage"

    var id: String { rawValue }

    /// Shown in the language picker, always in that language.
    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .italian:
            return "Italiano"
        case .persian:
            return "فارسی"
        }
    }

    var locale: Locale { Locale(identifier: rawValue) }

    var layoutDirection: LayoutDirection {
        self == .persian ? .rightToLeft : .leftToRight
    }

    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }
        return bundle
    }

    static var resolvedCode: String {
        if let stored = UserDefaults.standard.string(forKey: storageKey),
           Self(rawValue: stored) != nil {
            return stored
        }
        return matchedToDevice.rawValue
    }

    static var current: AppLanguage {
        language(for: resolvedCode)
    }

    static func language(for code: String) -> AppLanguage {
        AppLanguage(rawValue: code) ?? .english
    }

    static func text(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: current.bundle, locale: current.locale)
    }

    private static var matchedToDevice: AppLanguage {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("fa") { return .persian }
        if preferred.hasPrefix("it") { return .italian }
        return .english
    }
}
