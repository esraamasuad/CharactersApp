//
//  File.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation

public enum AppConstants {
    
    public static var host: String {
        return Bundle.main.infoDictionary!["APP_HOST"] as! String
    }
}
