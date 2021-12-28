//
//  Dummy.swift
//  FindPlacesTests
//
//  Created by yongcheol Lee on 2021/12/29.
//

import Foundation

@testable import FindPlaces

var cvsList: [KLDocument] = Dummy().load("networkDummy.json")

class Dummy {
    func load<T: Decodable>(_ filename: String) -> T {
        let data:Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: filename, withExtension: nil) else {
            fatalError("cannot load \(filename) from main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("cannot load \(filename) from main bundle. \(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("cannot parse \(filename) to \(T.self).")
        }
    }
    
}
