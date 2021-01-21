//
//  Router+Extensions.swift
//  App
//
//  Created by Joe Blau on 7/2/18.
//

import Vapor

extension Request {
    var acceptLanguage: String {
        get {
            let acceptLanguage = String(self.http
                .headers
                .firstValue(name: .acceptLanguage)?
                .split(separator: ",")
                .first?
                .split(separator: "-")
                .first ?? "en")
            let supportedLanguages = ["ar", "de", "en", "fa", "fr", "id", "ja", "ko", "pt", "ro", "ru", "tr", "zh"]
            if supportedLanguages.contains(acceptLanguage) {
                return acceptLanguage
            } else {
                return "en"
            }
        }
    }
}
