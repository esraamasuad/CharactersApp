//
//  File.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation
import Alamofire

public class SessionManager: SessionDelegate {
    
    static let shared = SessionManager()
    var manager: Session?
    
    init(){
        super.init()
        manager = Session(configuration: URLSessionConfiguration.ephemeral, delegate: self)
    }
}

