//
//  CustomCollectionView.swift
//  ListOrganisedView
//
//  Created by ilo on 13/09/2018.
//  Copyright © 2018 Big Bear Labs. All rights reserved.
//

import AppKit

class CustomCollectionView: NSCollectionView {

  var convertEnterToDoubleClick: Bool? = false
  
  override func keyDown(with event: NSEvent) {
    // special-case the return key.
    if event.charactersIgnoringModifiers == "\r" {
      if convertEnterToDoubleClick == true {
        if let vc = self.delegate as? GenericCollectionViewController {
          let model = vc.selectedItemModels[0]
          vc.onDoubleClick!(model, vc)
        }
      } else {
        self.nextResponder?.keyDown(with: event)
      }
    }
    else {
      super.keyDown(with: event)
    }
  }
}
