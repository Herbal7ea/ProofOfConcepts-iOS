//
//  MediaTranslator.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation
import CoreData

class MediaTranslator {
    func translate(media: Media?) -> MediaDao? {
        guard let media = media else { return nil }
        
        return MediaDao(id: media.id, url: media.url)
    }

    func translate(dao: MediaDao?, context: NSManagedObjectContext) -> Media? {
        guard let dao = dao else { return nil }
        
        let media = Media(context: context)
            media.id = dao.id
            media.url = dao.url

        return media
    }
}
