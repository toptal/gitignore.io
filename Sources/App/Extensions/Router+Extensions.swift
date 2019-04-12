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
            guard let accpetLanguage = self.http
                .headers
                .firstValue(name: .acceptLanguage)?
                .split(separator: ",")
                .first else {
                return "en"
            }
            switch accpetLanguage {
            case "en-US", "en-us": return "en"
            case "de-DE", "de-de": return "de_DE"
            case "pt-BR", "pt-br": return "pt_BR"
            case "ko-KR", "ko-kr": return "ko_KR"
            case "ro-RO", "ro-ro": return "ro_RO"
            case "tr-TR", "tr-tr": return "tr_TR"
            case "ar": return "ar"
            default: return "en"
            }
        }
    }
}
