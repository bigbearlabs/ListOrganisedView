import ListOrganisedView


import Foundation


struct CollectionItemModel: GenericCollectionItemModel, Codable, Equatable {
  
  func isEqual(to: GenericCollectionItemModel) -> Bool {
    if let other = to as? CollectionItemModel {
      return self == other
    }
    return false
  }
  
  var id: String = "stub-id"
  
  var url: URL
  
  var title: String? = nil
  
  var tooltipText: String? = nil
  
  
  init(id: String, url: URL, title: String? = nil, tooltipText: String? = nil) {
    self.id = id
    self.url = url
    self.title = title
    self.tooltipText = tooltipText
  }
  
  
  var dictionaryRepresentation: [String : Any?] {
    return
      try! JSONSerialization.jsonObject(
        with: try! JSONEncoder().encode(self),
        options: []) as! [String : Any?]
  }
  
}

