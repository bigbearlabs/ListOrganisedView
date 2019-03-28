import Cocoa


extension NSView {
  
  var onDoubleClick: (() -> ())? {
    get {
      return actionClosure(type: DoubleClickGestureRecognizer.self)
    }
    set {
      guard let onDoubleClick = newValue else { return }
      setActionClosure(onDoubleClick, forType: DoubleClickGestureRecognizer.self)
    }
  }
  
  var onRightClick: (() -> ())? {
    get {
      return actionClosure(type: RightClickGestureRecognizer.self)
    }
    set {
      guard let onRightClick = newValue else { return }
      setActionClosure(onRightClick, forType: RightClickGestureRecognizer.self)
    }
  }
  
  
  
  func actionClosure<T: ClosureActionGestureRecognizer>(type: T.Type) -> (() -> Void)? {
    let rs = self.gestureRecognizers.ofType(type)
    if let r = rs.last {
      return r.actionClosure
    }
    return nil
  }
  
  func setActionClosure<T: ClosureActionGestureRecognizer&NSGestureRecognizer>(_ actionClosure: @escaping () -> Void, forType type: T.Type) {
    let recogniser = type.init(action: actionClosure)
    let existingMatchingRecognisers = self.gestureRecognizers.ofType(type)
    
    self.gestureRecognizers =
      Set(self.gestureRecognizers)
        .subtracting(existingMatchingRecognisers)
        .map { $0 }
        + [recogniser]
  }
  
}


protocol ClosureActionGestureRecognizer {
  var actionClosure: () -> Void { get }
  
  init(action: @escaping () -> Void)
}



class DoubleClickGestureRecognizer: NSClickGestureRecognizer, ClosureActionGestureRecognizer {
  
  let actionClosure: () -> Void
  
  
  required init(action: @escaping () -> Void) {
    self.actionClosure = action
    
    super.init(target: nil, action: #selector(actionInvoked(_:)))
    
    self.numberOfClicksRequired = 1
    self.delaysPrimaryMouseButtonEvents = false
  }
  
  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)
    
    if event.clickCount == 2 {
      self.actionClosure()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction
  private func actionInvoked(_ sender: Any?) {
    // stub action method; logic in overridden #mouseDown.
  }
  
}


class RightClickGestureRecognizer: NSClickGestureRecognizer, ClosureActionGestureRecognizer {
  
  let closureHolder: ClosureHolder
  
  var actionClosure: () -> Void {
    return closureHolder.closure
  }
  
  required init(action: @escaping () -> Void) {
    let closureHolder = ClosureHolder(closure: action)
    self.closureHolder = closureHolder
    
    super.init(target: closureHolder, action: #selector(ClosureHolder.actionInvoked(_:)))
    
    self.numberOfClicksRequired = 1
    self.buttonMask = 0x2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  // indirect closure through a class since we are constrained to the recogniser's target property type.
  class ClosureHolder {
    
    let closure:  () -> ()
    
    init(closure: @escaping () -> ()) {
      self.closure = closure
    }

    @IBAction
    func actionInvoked(_ sender: Any?) {
      self.closure()
    }
    
  }
}


extension Sequence {
  func ofType<T>(_ type: T.Type) -> [T] {
    return self.compactMap {
      $0 as? T
    }
  }
}

