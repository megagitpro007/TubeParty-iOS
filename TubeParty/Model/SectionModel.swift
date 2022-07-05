//
//  SectionModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 5/7/2565 BE.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [MessageModel]
}

extension SectionModel: SectionModelType {
    
    var identify: String {
        header
    }
    
    init(original: SectionModel, items: [MessageModel]) {
        self = original
        self.items = items
    }
    
}
