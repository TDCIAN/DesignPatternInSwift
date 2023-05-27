# DesignPatternInSwift
   
   
   

## 1. Creational
### 1-1. Builder
    - Some objects are simple and can be created in a single initializer call
    - Other objects require a lot of ceremony to create
    - Having an object with 10 initializer arguments is not productive
    - Instead, opt for piecewise construction
    - Builder provides an API for constructing an object step-by-step
<br></br>
Builder pattern sample code
```swift
import Foundation

class Field: CustomStringConvertible {
    var type: String = ""
    var name: String = ""
    
    init(called name: String, ofType type: String) {
      self.name = name
      self.type = type        
    }
    
    public var description: String {
        return "var \(name): \(type)"
    }
}

class Class: CustomStringConvertible {
    var name = ""
    var fields = [Field]()
    
    public var description: String {
        var s = ""
        s.append("class \(name)\n{\n")
        for f in fields {
            s.append("  \(f)\n")
        }
        s.append("}\n")
        return s
    }
}

class CodeBuilder : CustomStringConvertible
{
  private var theClass = Class()
  
  init(_ rootName: String)
  {
    theClass.name = rootName
  }

  func addField(called name: String, ofType type: String) -> CodeBuilder
  {
    theClass.fields.append(Field(called: name, ofType: type))
    return self
  }

  public var description: String
  {
    return theClass.description
  }
}
```
###  1-2. Factories
####     1-2-1. Abstract Factory
####     1-2-2. Factory Method
###  1-3. Prototype
###  1-4. Singleton  
<br></br>
##  2. Structural
###   2-1. Adapter
###   2-2. Bridge
###   2-3. Composite
###   2-4. Decorator
###   2-5. Facade
###   2-6. Flyweight
###   2-7. Proxy
<br></br>
##  3. Behavioral
###   3-1. Chain of Responsibility
###   3-2. Command
###   3-3. Interpreter
###   3-4. Iterator
###   3-5. Mediator
###   3-6. Memento
###   3-7. Null Object
###   3-8. Observer
###   3-9. State
###   3-10. Strategy
###   3-11. Template Method
###   3-12. Visitor
