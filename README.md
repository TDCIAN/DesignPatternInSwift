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
<br></br>
Builder pattern summary
- A builder is a separate component for building an object
- Can either give builder an initializer or return it via a static function
- To make builder fluent, return self
- Different facets of an object can be built with different builders working in tandem via a base class
<br></br>
###  1-2. Factories
    - Object creation logic becomes too convoluted
    - Initializer is not descriptive
      - Name mandated to be init
      - Can overload with same sets of arguments with different names
        - Works to some degree
    - Object creation(non-piecewise, unlike Builder) can be outsourced to
      - A separate function (Factory Method)
      - That may exist in a separate class (Factory)
      - Can create hierarchy of factories with Abstract Factory
    - Factory is a component responsible soley for the wholesale(not piecewise) creation of objects.   

####     1-2-1. Abstract Factory
####     1-2-2. Factory Method
<br></br>
Factory pattern sample code
```swift
import Foundation

class Person
{
  var id: Int
  var name: String

  init(called name: String, withId id: Int)
  {
    self.name = name
    self.id = id
  }
}

class PersonFactory
{
  private var id = 0
  
  func createPerson(name: String) -> Person
  {
    let person = Person(called: name, withId: id)
    id += 1
    return person
  }
}
```
<br></br>
Factory pattern summary
- A factory method is a static method that creates objects
- A factory can take care of object create
- A factory can be external or reside inside the object as an inner class
- Hierarchies of factories can be used to create related objects
<br></br>
###  1-3. Prototype
    - Complicated object(e.g., cars) aren't designed from scratch -> they reiterate existing designs
    - An existing(partially or fully constructed) design is a Prototype
    - We make a copy(clone) the prototype and customize it -> Requires 'deep copy' support
    - We can make the cloning convenient (e.g., via a Factory)
    - A partially or fully initialized object that you copy(clone) and make use of.
<br></br>
Prototype pattern sample code
```swift
import Foundation

class Point {
  var x = 0
  var y = 0

  init() {}

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

class Line {
  var start = Point()
  var end = Point()

  init(start: Point, end: Point) {
    self.start = start
    self.end = end
  }

  func deepCopy() -> Line {
    let newStart = Point(x: start.x, y: start.y)
    let newEnd = Point(x: end.x, y: end.y)
    return Line(start: newStart, end: newEnd)
  }
}
```
<br></br>
Prototype pattern summary
- To implement a prototype, partially(or fully) construct an object and store it somewhere
- Clone the prototype
  - Make a copying initializer
  - Implement your own deep copy functionality
- Customize the resulting instance
<br></br>    
###  1-4. Singleton
    - For some components it only makes sense to have one in the system
      - Database repository
      - Object factory
    - E.g., the initializer call is expensive
      - We only do it once
      - We provide everyone with the same instance
    - Want to prevent anyone creating additional copies
    - Need to take care of lazy instantiation and thread safety
    - A component which is instantiated only once.
<br></br>
Singleton pattern sample code
```swift
import Foundation

class SingletonTester
{
  static func isSingleton(factory: () -> AnyObject) -> Bool
  {
    let obj1 = factory()
    let obj2 = factory()
    return obj1 === obj2
  }
}
```
<br></br>
Singleton pattern summary
- Making a 'safe' singleton is easy: construct a static(optionally lazy) property and return its value
- Singletons are difficult to test
- Instead of directly using a singleton, consider depending on an abstraction (e.g., a protocol)
- Consider defining singleton lifetime in DI container
<br></br>  
<br></br>
##  2. Structural
###   2-1. Adapter
    - We cannot modify our gadgets to support every possible interface
    - Thus, we use ad special device(an adapter) to give us the interface we require from the interface we have
    - A construct which adapts an existing interface X to conform to the required interface Y.
<br></br>
Adapter pattern sample code
```swift
import Foundation

class Square
{
  var side = 0

  init(side: Int)
  {
    self.side = side
  }
}

protocol Rectangle
{
  var width: Int { get }
  var height: Int { get }
}

extension Rectangle
{
  var area: Int
  {
    return self.width * self.height
  }
}

class SquareToRectangleAdapter : Rectangle
{
  private let square: Square
  
  init(_ square: Square)
  {
    self.square = square
  }

  var width: Int {
      return square.side
  }
  var height: Int {
      return square.side
  }
}
```
<br></br>
Adapter pattern summary
- Implementing an Adapter is easy
- Determine the API you have and the API you need
- Create a component which aggregates(has a reference to, ...) the adaptee
- Intermediate representations can pile up: use caching and other optimizations
<br></br>
###   2-2. Bridge
    - We cannot modify our gadgets to support every possible interface
    - Thus, we use ad special device(an adapter) to give us the interface we require from the interface we have
    - A construct which adapts an existing interface X to conform to the required interface Y.
<br></br>
Bridge pattern sample code
```swift
import Foundation

protocol Renderer
{
  var whatToRenderAs: String { get }
}

class Shape : CustomStringConvertible
{
  private let renderer: Renderer

  init(_ renderer: Renderer)
  {
    self.renderer = renderer
  }

  var name: String = ""

  var description: String
  {
    return "Drawing \(name) as \(renderer.whatToRenderAs)"
  }
}

class Triangle : Shape
{
  override init(_ renderer: Renderer)
  {
    super.init(renderer)
    name = "Triangle"
  }
}

class Square : Shape
{
  override init(_ renderer: Renderer)
  {
    super.init(renderer)
    name = "Square"
  }
}

class RasterRenderer : Renderer
{
  var whatToRenderAs: String {
    return "pixels"
  }
}

class VectorRenderer : Renderer
{
  var whatToRenderAs: String
  {
    return "lines"
  }
}
```
<br></br>
Bridge pattern summary
- Decouple abstraction from implementation
- Both can exist as hierarchies
- A stronger form of encapsulation
<br></br>
###   2-3. Composite
    - Objects use other objects' properties/members through inheritance and composition
    - Composition lets us make compound objects
      - E.g., a mathematical expression composed of simple expressions; or
      - A grouping of shapes that consist of several shapes
    - Composite design pattern is used to treat both single(scalar) and composite objects uniformly
      - I.e., Foo and Sequence (yielding Foo's) have common APIs
    - A mechanism for treating individual(scalar) objects and compositions of objects in a uniform manner
<br></br>
Composite pattern sample code
```swift
import Foundation

class SingleValue : Sequence
{
  var value = 0

  init() {}
  init(_ value: Int)
  {
    self.value = value
  }

  func makeIterator() -> IndexingIterator<Array<Int>>
  {
    return IndexingIterator(_elements: [value])
  }
}

class ManyValues : Sequence
{
  var values = [Int]()

  func makeIterator() -> IndexingIterator<Array<Int>>
  {
    return IndexingIterator(_elements: values)
  }

  func add(_ value: Int)
  {
    values.append(value)
  }
}

extension Sequence where Iterator.Element: Sequence, Iterator.Element.Iterator.Element == Int
{
  func sum() -> Int
  {
    var result = 0
    for c in self {
        for i in c {
            result += i
        }
    }
    return result
  }
}
```
<br></br>
Composite pattern summary
- Objects can use other objects via inheritance/composition
- Some composed and singular objects need similar/identical behaviors
- Composite design pattern lets us treat both types of objects uniformly
- Swift has special support for the sequence concept
- A single object can masquerade as a collection with an iterator that uses [self]
<br></br>
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
