//
//  CharacteristicFormatter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import Foundation

class CharacteristicFormatter {
    static func getDetailSection(with data: CharacteristicData) -> [CharacteristicDetailRow] {
        var rows = [CharacteristicDetailRow]()
        
        let titleRow = getDetailTitleRow(with: data)
        rows.append(titleRow)
        
        let readTitle = getReadTitleRow(with: data)
        rows.append(readTitle)
        
        let responseRow = getDetailRows(with: data)
        rows.append(responseRow)
        
        if !data.isReadOnly {
            let writeTitle = getWriteTitleRow()
            rows.append(writeTitle)
            
            let writeRow = getWriteRow()
            rows.append(writeRow)
        }
        
        let propertiesTitle = getPropertiesTitleRow()
        rows.append(propertiesTitle)
        
        var properties = [StringContext.propertyRead]
        
        if data.willNotify {
            properties.append(StringContext.propertyNotify)
        }
        
        if !data.isReadOnly {
            properties.append(StringContext.propertyWrite)
        }
        
        for property in properties {
            let isLast = property == properties.last
            let propertyRow = getPropertyRow(title: property, isLast: isLast)
            rows.append(propertyRow)
        }
        
        return rows
    }
    
    static private func getReadTitleRow(with data: CharacteristicData) -> CharacteristicDetailRow {
        let title = data.willNotify
        ? StringContext.readNotifiedValues
        : StringContext.readValues
        
        return CharacteristicDetailRow.topTitleRow(model: title)
    }
    
    static private func getWriteTitleRow() -> CharacteristicDetailRow {
        let title = StringContext.writeValue
        
        return CharacteristicDetailRow.topTitleRow(model: title)
    }

    static private func getWriteRow() -> CharacteristicDetailRow {
        let model = CommonDetailRowUIModel(title: StringContext.writeValue,
                                           value: StringContext.Separator.space,
                                           shouldShowSeparator: false)
        
        return CharacteristicDetailRow.writeRow(model: model)
    }
    
    static private func getDetailTitleRow(with data: CharacteristicData) -> CharacteristicDetailRow {
        let titleUIModel = CharacteristicDetailUIModel(data: data)
        return CharacteristicDetailRow.titleRow(model: titleUIModel)
    }
    
    static private func getDetailRows(with data: CharacteristicData) -> CharacteristicDetailRow {
        
        let response = getJSONResponse(using: data)
        
        let uiModel = CommonDetailRowUIModel(title: StringContext.Separator.empty,
                                             value: response,
                                             shouldShowSeparator: false)
        return CharacteristicDetailRow.staticRow(model: uiModel)
    }
    
    static private func getPropertiesTitleRow() -> CharacteristicDetailRow {
        let title = StringContext.properties
        
        return CharacteristicDetailRow.topTitleRow(model: title)
    }
    
    static private func getPropertyRow(title: String, isLast shouldHideSeparator: Bool = false) -> CharacteristicDetailRow {
        let model = CommonDetailRowUIModel(title: title, value: "", shouldShowSeparator: !shouldHideSeparator)
        
        return CharacteristicDetailRow.propertyRow(model: model)
    }
}

extension CharacteristicFormatter {
    private static func getJSONResponse(using data: CharacteristicData) -> String {
        guard let response = data.response else { return "" }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let json = try encoder.encode(response)
            return String(data: json, encoding: .utf8) ?? ""
        } catch {
            dump("DEBUG: \(error)")
        }
        
        return StringContext.Separator.empty
    }
}
