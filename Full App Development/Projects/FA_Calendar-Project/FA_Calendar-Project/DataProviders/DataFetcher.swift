//
//  DataFetcher.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/6/26.
//
import Foundation
import Observation

@Observable
class DataFetcher {
    var dataProvider: ServerDataProvider = ServerDataProvider()
}
