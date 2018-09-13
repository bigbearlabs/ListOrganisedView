//
//  CustomCollectionView.swift
//  ListOrganisedView
//
//  Created by ilo on 13/09/2018.
//  Copyright © 2018 Big Bear Labs. All rights reserved.
//

import AppKit

class CustomCollectionView: NSCollectionView {

  override func keyDown(with event: NSEvent) {
    // special-case the return key.
    if event.charactersIgnoringModifiers == "\r" {
      if let vc = self.delegate as? GenericCollectionViewController {
        let model = vc.selectedItemModels[0]
        vc.onDoubleClick!(model, vc)
      }
    }
    else {
      super.keyDown(with: event)
    }
  }
}
