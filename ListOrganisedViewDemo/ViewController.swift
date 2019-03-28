import Cocoa
import ListOrganisedView

import WebKit


class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupListOrganisedViewController()
  }
  
}

// MARK: -

extension ViewController {
  
  func setupListOrganisedViewController() {
    self.listOrganisedViewController.listWidth =
//      self.listOrganisedViewController.view.frame.size.width
      80
    
    self.listOrganisedViewController.itemModels = [
      {
        let o = CollectionItemModel(
          id: "google",
          url: URL(string: "https://google.com")!,
          title: "Google")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "GitHub",
          url: URL(string: "https://github.com")!,
          title: "GitHub")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "Twitter",
          url: URL(string: "https://twitter.com")!,
          title: "Twitter")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "MacRumors",
          url: URL(string: "https://macrumors.com")!,
          title: "MacRumors")
        return o
      }(),
    ]
    
    self.listOrganisedViewController.onSelect = self.onSelect
  }

  func onSelect(models: [GenericCollectionItemModel], viewController: GenericCollectionViewController) {
    guard models.count < 2 else { fatalError() }
    guard let model = models.first as? CollectionItemModel else { return }
    
    self.listOrganisedViewController.showContent(
      modelObject: model,
      initialiseViewControllerForModel: {
        let viewControllerForModel = controllerFromStoryboard(
          name: "WebView",
          bundle: Bundle(for: type(of: self))
          ) as! NSViewController
        return viewControllerForModel
    }) { viewControllerForModel in
      // instruct the vc.
      
      let webView = viewControllerForModel.view as! WKWebView
      let url = model.url
      webView.load(URLRequest(url: url))
      
    }
  }
  

  var listOrganisedViewController: ListOrganisedViewController {
    return self.children.compactMap { $0 as? ListOrganisedViewController}.last!
  }
  
}


// MARK: -

func controllerFromStoryboard(name: NSStoryboard.Name, bundle: Bundle? = nil) -> Any? {
  let storyboard = NSStoryboard(name: name, bundle: bundle)
  return storyboard.instantiateInitialController()
}
