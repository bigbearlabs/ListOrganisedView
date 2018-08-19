//: Playground - noun: a place where people can play

import Cocoa
import ListOrganisedView
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func testViewControllerInStoryboard() -> NSViewController? {
  let storyboard = NSStoryboard(name: NSStoryboard.Name("ListOrganisedView"), bundle: Bundle(identifier: "com.bigbearlabs.ListOrganisedView"))
  if let listOrganisedViewController = storyboard.instantiateInitialController() as? ListOrganisedViewController {

    PlaygroundPage.current.liveView = listOrganisedViewController
    
    return listOrganisedViewController
  }
  
  return nil
}


let vc = testViewControllerInStoryboard()
vc?.view

