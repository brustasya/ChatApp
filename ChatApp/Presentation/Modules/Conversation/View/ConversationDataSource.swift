//
//  ConversationDataSource.swift
//  ChatApp
//
//  Created by Станислава on 27.04.2023.
//

import UIKit

final class DataSourceForConversation: UITableViewDiffableDataSource<Date, MessageModel> {
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self.snapshot().sectionIdentifiers[section])
    }
}
