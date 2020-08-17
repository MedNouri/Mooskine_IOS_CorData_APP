//
//  Note+extension.swift
//  Mooskine
//
//  Created by Mohamed Nouri on 12/08/2020.
//  Copyright © 2020 Mohamed Nouri. All rights reserved.
//

import Foundation
import CoreData



extension Note {
    
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creadtionDate = Date()
    }
    
}
