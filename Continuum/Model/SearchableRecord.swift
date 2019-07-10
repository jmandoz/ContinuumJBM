//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
