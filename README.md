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
    - Want to augment an object with additional functionality
    - Do not want to rewrite or alter existing code (OCP)
    - Want to keep new functionality separate (SRP)
    - Need to be able to interact with existing structures
    - Two options:
      - Inherit from required object if possible; some objects are final
      - Build a Decorator, which simply references the decorated object(s)
    - Facilitates the addition of behaviors to individual objects without inheriting from them.
<br></br>
Decorator pattern sample code
```swift
import Foundation

class Bird
{
  var age = 0

  func fly() -> String
  {
    return (age < 10) ? "flying" : "too old"
  }
}

class Lizard
{
  var age = 0

  func crawl() -> String
  {
    return (age > 1) ? "crawling" : "too young"
  }
}

class Dragon
{
  private var _age = 0
  private let bird = Bird()
  private let lizard  = Lizard()

  var age: Int {
    get { 
        return _age 
    }
    set(value) {
        bird.age = value
        lizard.age = value
        _age = value
    }
  }
  func fly() -> String { 
    return bird.fly()
  }
  func crawl() -> String { 
    return lizard.crawl()
  }
}
```
<br></br>
Decorator pattern summary
- A decorator keeps reference to the decorated object(s)
- May or may not proxy over calls
  - Functions, operators, etc.
- Exists in a static variation
  - X<Y<Foo>>
  - Very limited due to inability to inherit initializers from type parameters
<br></br>
###   2-5. Facade
    - Balancing complexity and presentation/usability
    - Typical home
      - Many subsystems (electrical, sanitation)
      - Complex internal structure (e.g., floor layers)
      - End user is not exposed to internals
    - Same with software
      - Many systems working to provide flexibility, but API consumers want it to 'just work'
    - Provide a simple, easy to understand/user interface over a large and sophisticated body of code.
<br></br>
Facade pattern sample code
```swift
import Foundation

class Generator
{
  func generate(_ count: Int) -> [Int]
  {
    var result = [Int]()
    for _ in 1...count
    {
      result.append(1 + random()%9)
    }
    return result
  }
}

class Splitter
{
  func split(_ array: [[Int]]) -> [[Int]]
  {
    var result = [[Int]]()
    
    let rowCount = array.count
    let colCount = array[0].count

    // get the rows
    for r in 0..<rowCount
    {
      var theRow = [Int]()
      for c in 0..<colCount
      {
        theRow.append(array[r][c])
      }
      result.append(theRow)
    }

    // get the columns
    for c in 0..<colCount
    {
      var theCol = [Int]()
      for r in 0..<rowCount
      {
        theCol.append(array[r][c])
      }
      result.append(theCol)
    }

    // get the diagonals
    var diag1 = [Int]()
    var diag2 = [Int]()
    for c in 0..<colCount
    {
      for r in 0..<rowCount
      {
        if c == r
        {
          diag1.append(array[r][c])
        }
        let r2 = rowCount - r - 1
        if c == r2
        {
          diag2.append(array[r][c])
        }
      }
    }

    result.append(diag1)
    result.append(diag2)

    return result
  }
}

class Verifier
{
  func verify(_ arrays: [[Int]]) -> Bool
  {
    let first = arrays[0].reduce(0, +)
    for arr in 1..<arrays.count
    {
      if (arrays[arr].reduce(0, +)) != first
      {
        return false
      }
    } 
    return true
  }
}

class MagicSquareGenerator
{
  func generate(_ size: Int) -> [[Int]]
  {
    let g = Generator()
    let s = Splitter()
    let v = Verifier()

    var square: [[Int]]
    repeat 
    {
      square = [[Int]]() 
      for _ in 1...size
      {
        square.append(g.generate(size))
      }
    } while !v.verify(s.split(square))
    return square
  }
}
```
<br></br>
Facade pattern summary
- Build a Facade to provide a simplified API over a set of classes
- May wish to (optionally) expose internals through the facade
- May allow users to 'escalate' to use more complex APIs if they need to
<br></br>
###   2-6. Flyweight
    - Avoid redundancy when storing data
    - E.g., MMORPG
      - Plenty of users with identical first/last names
      - No sense in storing same first/last name over and over again
      - Store a list of names and pointers to them
    - String interning would not help
    - E.g., bold or italic text in the console
      - Don't want each character to have a formatting character
      - Operater on ranges (e.g., line number, start/end positions)
    - A space optimization technique that lets us use less memory by storing externally the data associated with similar objects.
<br></br>
Flyweight pattern sample code
```swift
import Foundation

class Sentence : CustomStringConvertible
{
  var words: [String]
  var tokens = [Int: WordToken]()
  
  init(_ plainText: String) {
    words = plainText.components(separatedBy: " ")
  }

  subscript(index: Int) -> WordToken {
    get {
        let wordToken = WordToken()
        tokens[index] = wordToken
        return tokens[index]!
    }
  }

  var description: String {
    var ws = [String]()
    for i in 0..<words.count {
        var w = words[i]
        if let item = tokens[i] {
            if item.capitalize {
                w = w.uppercased()
            }
        }
        ws.append(w)
    }
    return ws.joined(separator: " ")
  }

  class WordToken
  {
    var capitalize: Bool = false
    
    init() {
        
    }
    init(capitalize: Bool) {
        self.capitalize = capitalize
    }
  }
}
```
<br></br>
Flyweight pattern summary
- Store common data externally
- Define the idea of 'ranges' on homogeneous collections and store data related to those ranges
<br></br>
###   2-7. Proxy
    - You are calling foo.Bar()
    - This assumes that foo is in the same process as Bar()
    - What if, later on, you want to put all Foo-related operations into a separate process
      - Can you avoid changing your code?
    - Proxy to the rescue!
      - Same interface, entirely different behavior
    - This is called a communication proxy
      - Other types: logging, virtual, guarding
    - Proxy is a class that functions as an interface to a particular resource. That resource may be remote, expensive to construct, or may require logging or some other added functionality.
<br></br>
Proxy vs. Decorator
- Proxy provides an identical interface; decorator provides an enhanced interface
- Decorator typically aggregates (or has reference to) what it is decorating; proxy doesn't have to
- Proxy might not even be working with a materialized object
<br></br>
Proxy pattern sample code
```swift
class Person
{
  var age: Int = 0

  func drink() -> String
  {
    return "drinking"
  }

  func drive() -> String
  {
    return "driving"
  }

  func drinkAndDrive() -> String
  {
    return "driving while drunk"
  }
}

class ResponsiblePerson
{
  private let person: Person

  init(person: Person)
  {
    self.person = person
  }

  var age: Int {
      get {
          return person.age
      }
      set(newValue) {
          self.person.age = newValue
      }
  }
  func drink() -> String
  {
    return age >= 18 ? person.drink() : "too young"
  }

  func drive() -> String
  {
    return age >= 16 ? person.drive() : "too young"
  }

  func drinkAndDrive() -> String
  {
    return "dead"
  }
}
```
<br></br>
Proxy pattern summary
- A proxy has the same interface as the underlying object
- To create a proxy, simply replicate the existing interface of an object
- Add relevant functionality to the redefined member functions
- Different proxies (communication, logging, caching, etc.) have completely different behaviors
<br></br>
<br></br>
##  3. Behavioral
###   3-1. Chain of Responsibility
    - Unethical behavior by an employee; who takes the blame?
      - Employee
      - Manager
      - CEO
    - You click a graphical element on a form
      - Button handles it, stops further processing
      - Underlying group box
      - Underlying window
    - CCG computer game
      - creature has attck and defense values
      - Those can be boosted by other cords
    - A chain of components who all get a chance to process a command or a query, optionally having default processing implementation and an ability to terminate the processing chain.
    
<br></br>
Chain of responsibility sample code
```swift
import Foundation

class Creature
{
  let game: Game
  let baseAttack: Int
  let baseDefense: Int

  internal init(game: Game, baseAttack: Int, baseDefense: Int)
  {
    self.game = game
    self.baseAttack = baseAttack
    self.baseDefense = baseDefense
  }

  // the rest of the members are typically 'abstract'
  var attack: Int
  {
    get { return baseAttack }
  }

  var defense: Int
  {
    get { return baseDefense }
  }

  func query(_ source: AnyObject, _ sq: StatQuery) {}
}

class Goblin : Creature
{
  override func query(_ source: AnyObject, _ sq: StatQuery)
  {
    if (source === self)
    {
      switch sq.statistic
      {
        case .attack: sq.result += baseAttack
        case .defense: sq.result += baseDefense
      }
    }
    else
    {
      // a Goblin gets +1 def for every other goblin in play
      if (sq.statistic == .defense)
      {
        sq.result += 1
      }
    }
  }

  override var defense: Int
  {
    get {
      let q = StatQuery(.defense)
      for c in game.creatures
      {
        c.query(self, q)
      }
      return q.result
    }
  }

  override var attack: Int
  {
    get
    {
      let q = StatQuery(.attack)
      for c in game.creatures
      {
        c.query(self, q)
      }
      return q.result
    }
  }

  convenience init(game: Game)
  {
    self.init(game: game, baseAttack: 1, baseDefense: 1)
  }
}

class GoblinKing : Goblin
{
  init(game: Game)
  {
    super.init(game: game, baseAttack: 3, baseDefense: 3)
  }

  override func query(_ source: AnyObject, _ sq: StatQuery)
  {
    // gives every _other_ goblin +1 attack
    if (source !== self && sq.statistic == .attack)
    {
      sq.result += 1
    } else {
      // the king is also a goblin, so...
      super.query(source, sq)
    }
  }
}

enum Statistic
{
  case attack
  case defense
}

class StatQuery
{
  var statistic: Statistic
  var result: Int = 0

  init(_ statistic: Statistic)
  {
    self.statistic = statistic
  }
}

class Game
{
  var creatures = [Creature]()
}
```
<br></br>
Chain of responsibility summary
- Chain of Responsibility can be implemented as a chain of references or a centralized construct
- Enlist objects in the chain, possibly controlling their order
- Object removal from chain (e.g., in dispose())
<br></br>
###   3-2. Command
    - Ordinary statements are perishable
      - Cannot undo a property assignment
      - Cannot directly serialize a sequence of actions (calls)
    - What an object that represents an operation
      - X should change its property y to z
      - X should do w()
    - Uses: GUI commands, multi-level undo/redo, macro recording and more!
    - An object which represents an instruction to perform a particular action. Contains all the information necessary for the action to be taken.
    
<br></br>
Command sample code
```swift
import Foundation

class Creature
{
  let game: Game
  let baseAttack: Int
  let baseDefense: Int

  internal init(game: Game, baseAttack: Int, baseDefense: Int)
  {
    self.game = game
    self.baseAttack = baseAttack
    self.baseDefense = baseDefense
  }

  // the rest of the members are typically 'abstract'
  var attack: Int
  {
    get { return baseAttack }
  }

  var defense: Int
  {
    get { return baseDefense }
  }

  func query(_ source: AnyObject, _ sq: StatQuery) {}
}

class Goblin : Creature
{
  override func query(_ source: AnyObject, _ sq: StatQuery)
  {
    if (source === self)
    {
      switch sq.statistic
      {
        case .attack: sq.result += baseAttack
        case .defense: sq.result += baseDefense
      }
    }
    else
    {
      // a Goblin gets +1 def for every other goblin in play
      if (sq.statistic == .defense)
      {
        sq.result += 1
      }
    }
  }

  override varclass Command
{
  enum Action
  {
    case deposit
    case withdraw
  }

  var action: Action
  var amount: Int
  var success = false

  init(_ action: Action, _ amount: Int)
  {
    self.action = action
    self.amount = amount
  }
}

class Account
{
  var balance = 0

  func process(_ c: Command)
  {
    switch c.action {
        case .deposit:
            balance += c.amount
            c.success = true
        case .withdraw:
            if balance - c.amount >= 0 {
                balance -= c.amount
                c.success = true
            } else {
                c.success = false
            }
    }
  }
}
```
<br></br>
Command summary
- Encapsulate all details of an operation in a separate object
- Define instruction for applying the command (either in the command itself, or elsewhere)
- Optionally define instructions for undoing the command
- Can create composite commands (a.k.a. macros)
<br></br>
###   3-3. Interpreter
    - Textual input needs to be processed
      - E.g., turned into OOP structures
    - Some examples
      - Programming laungage compilers, interpreters and IDEs
      - HTML, XML and similar
      - Numeric expressions (3+4/5)
      - Regular expressions
    - Turning strings into OOP based structures in a complicated process
    - A component that processes structured text data. Does so by turning it into separate lexical tokens(lexing) and then interpreting sequences of said tokens(parsing).
<br></br>
Interpreter sample code
```swift
import Foundation

extension String
{
  func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>]
  {
    var result: [Range<Index>] = []
    var start = startIndex
    while let range = range(of: string, options: options, range: start..<endIndex)
    {
      result.append(range)
      start = range.upperBound
    }
    return result
  }

  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }

  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }

  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return self[Range(start ..< end)]
  }
}

class ExpressionProcessor
{
  var variables = [Character:Int]()

  enum NextOp
  {
    case nothing
    case plus
    case minus
  }
  
  func calculate(_ expression: String) -> Int
  {
    var current = 0
    var nextOp = NextOp.nothing

    var parts = [String]()
    var buffer = ""

    // regex lookbehind in swift is broken, so we split the strings by hand
    for c in expression.characters
    {
      buffer.append(c)
      if (c == "+" || c == "-")
      {
        parts.append(buffer)
        buffer = ""
      }
    }
    if !buffer.isEmpty { parts.append(buffer) }

    for part in parts
    {
      var noOp = part.characters.split { ["+", "-"]
        .contains(String($0)) }
      var value = 0
      var first = String(noOp[0])

      if let z = Int(first)
      {
        value = z
      }
      else if (first.utf8.count == 1 && variables[first[0]] != nil)
      {
        value = variables[first[0]]!
      }
      else
      {
        return 0
      }

      switch nextOp
      {
        case .nothing:
          current = value
        case .plus:
          current += value
        case .minus:
          current -= value
      }

      if part.hasSuffix("+")
      {
        nextOp = .plus
      }
      else if part.hasSuffix("-")
      {
        nextOp = .minus
      }
    }

    return current
  }
}
```
<br></br>
Interpreter summary
- Barring simple cases, an interpreter acts in two stages
- Lexing turns text into a set of tokens
- Parsing tokens into meaningful constructs
- Parsed data can then be traversed
<br></br>
###   3-4. Iterator
    - Iteration(traversal) is a core functionality of various data structures
    - An iterator is a class that facilitates the traversal
      - Keeps a reference to the current element
      - Knows how to move t a differnt element
    - Iterator is an implicit construct
      - for x in y: no obvious iterator construction
    - An object(or a method) that facilitates the traversal of a data structure.
<br></br>
Iterator sample code
```swift
import Foundation

class Node<T>
{
  let value: T
  var left: Node<T>? = nil
  var right: Node<T>? = nil
  var parent: Node<T>? = nil

  init(_ value: T)
  {
    self.value = value
  }

  init(_ value: T, _ left: Node<T>, _ right: Node<T>)
  {
    self.value = value
    self.left = left
    self.right = right

    left.parent = self
    right.parent = self
  }

  private func traverse(_ current: Node<T>, _ buffer: inout [T]) {
      buffer.append(current.value)
      
      if let currentLeft = current.left {
          traverse(currentLeft, &buffer)
      }
      if let currentRight = current.right {
          traverse(currentRight, &buffer)
      }
  }
  
  public var preOrder: [T]
  {
    get {
        var buffer = [T]()
        traverse(self, &buffer)
        return buffer
    }
  }
}
```
<br></br>
Iterator summary
- An iterator specified how you can traverse an object
- An iterator object, unlike a method, cannot be recursive
- Return an iterator from a Sequence and you can use your object in a for loop
<br></br>
###   3-5. Mediator
    - Components may go in and out of a system at any time
      - Chat room participants
      - Players in an MMORPG
    - It makes no sense for them to have direct references to one another
      - Those references may go dead
    - Solution: have them all refer to some central component that facilitates communication
    - A component that facilitates communication between other components without them necessarily being aware of each other or having direct(reference) access to each other
<br></br>
Mediator sample code
```swift
public protocol Disposable
{
  func dispose()
}

protocol Invocable : class
{
  func invoke(_ data: Any)
}

public class Event<T>
{
  public typealias EventHandler = (T) -> ()

  var eventHandlers = [Invocable]()

  public func raise(_ data: T)
  {
    for handler in self.eventHandlers
    {
      handler.invoke(data)
    }
  }

  public func addHandler<U: AnyObject>
    (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
  {
    let subscription = Subscription(target: target, handler: handler, event: self)
    eventHandlers.append(subscription)
    return subscription
  }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
  weak var target: T?
  let handler: (T) -> (U) -> ()
  let event: Event<U>

  init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
  {
    self.target = target
    self.handler = handler
    self.event = event
  }

  func invoke(_ data: Any) {
    if let t = target {
      handler(t)(data as! U)
    }
  }

  func dispose()
  {
    event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
  }
}

class Participant
{
  private let mediator: Mediator
  var value = 0

  init(_ mediator: Mediator)
  {
    self.mediator = mediator
    mediator.alert.addHandler(
      target: self,
      handler: {
        (_) -> ((AnyObject, Int)) -> () in
        return self.alert
      }
    )
  }

  func alert(_ data: (AnyObject, Int))
  {
    if (data.0 !== self)
    {
      value += data.1
    }
  }

  func say(_ n: Int)
  {
    mediator.broadcast(self, n)
  }
}

class Mediator
{
  let alert = Event<(AnyObject, Int)>()

  func broadcast(_ sender: AnyObject, _ n: Int)
  {
    alert.raise(sender, n)
  }
}
```
<br></br>
Mediator summary
- Create the mediator and have each object in the system refer to it
  - E.g., in a property
- Mediator engages in bidirectional communication with its connected components
- Mediator has functions the components can call
- Components have functions the mediator can call
- Event processing (e.g., Rx) libraries make communication easier to implement
<br></br>
###   3-6. Memento
    - An object or system goes through changes
      - E.g., a bank account gets deposits and withdrawls
    - There are different ways of navigating those changes
    - One way is to record every change(Command) and teach a command to 'undo' itself
    - Another is to simply save snapshots of the system(Memento)
    - A token/handle representing the system state. Lets us roll back to the state when the token was generated. May or may not directly expose state information.
<br></br>
Memento sample code
```swift
import Foundation

class Token
{
  var value = 0
  init(_ value: Int)
  {
    self.value = value
  }
  init(copyFrom other: Token)
  {
    self.value = other.value
  }
  static func ==(_ lhs: Token, _ rhs: Token) -> Bool
  {
    return lhs.value == rhs.value
  }
}

class Memento
{
  var tokens = [Token]()
}

class TokenMachine
{
  var tokens = [Token]()

  func addToken(_ value: Int) -> Memento
  {
    tokens.append(Token(value))
    let m = Memento()
    m.tokens = tokens.map{Token(copyFrom: $0)}
    return m
  }

  func addToken(_ token: Token) -> Memento
  {
    tokens.append(token)
    let m = Memento()
    m.tokens = tokens.map{Token(copyFrom: $0)}
    return m
  }

  func revert(to m: Memento)
  {
    tokens = m.tokens.map{ Token(copyFrom: $0) }
  }
}
```
<br></br>
Memento summary
- Mementos are used to roll back states arbitrarily
- A memento is simply a token/handle class with(typically) no functions of its own
- A memento is not required to expose directly the state(s) to which it reverts the system
- Can be used to implement undo/redo
<br></br>
###   3-7. Null Object
    - When component A uses component B, it typically assumes that B is not nil
      - You inject B, not B? or some Option<B>
      - You do not check for nil (?.) on every call
    - There is no option of telling A not to use an instance of B
      - Its use is hard-coded
    - Thus, we build a no-op, non-functioning inheritor of B and pass it into A
    - A no-op object that conforms to the required interface, satisfying a dependency requirement of some other object.
<br></br>
Null Object sample code
```swift
protocol Log
{
  var recordLimit: Int { get }
  var recordCount: Int { get set }
  func logInfo(_ message: String)
}

enum LogError : Error
{
  case recordNotUpdated
  case logSpaceExceeded
}

class Account
{
  private var log: Log

  init(_ log: Log)
  {
    self.log = log
  }

  func someOperation() throws
  {
    let c = log.recordCount
    log.logInfo("Performing an operation")
    if (c+1) != log.recordCount
    {
      throw LogError.recordNotUpdated
    }
    if log.recordCount >= log.recordLimit
    {
      throw LogError.logSpaceExceeded
    }
  }
}

class NullLog : Log
{
  var recordLimit: Int
  {
    return Int.max
  }
  var recordCount: Int = Int.min
  func logInfo(_ message: String)
  {
    recordCount += 1
  }
}
```
<br></br>
Null Object summary
- Implement the required interface
- Rewrite the methods with empty bodies
  - If method is non-void, return default
  - If these values are ever used, you are in trouble
- Supply an instance of Null Object in place of actual object
<br></br>
###   3-8. Observer
    - We need to be informed when certain things happen
      - Object's property changes
      - Object does something
      - Some external event occurs
    - We want to listen to events and notified when they occur
    - Built into Swift for properties only
    - An observer is an object that wishes to be informed about events happening in the system. The entity generating the events is an observable.
<br></br>
Observer sample code
```swift
import Foundation

protocol Invocable : class
{
  func invoke(_ data: Any)
}

public protocol Disposable
{
  func dispose()
}

public class Event<T>
{
  public typealias EventHandler = (T) -> ()

  var eventHandlers = [Invocable]()

  public func raise(_ data: T)
  {
    for handler in self.eventHandlers
    {
      handler.invoke(data)
    }
  }

  public func addHandler<U: AnyObject>
    (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
  {
    let subscription = Subscription(target: target, handler: handler, event: self)
    eventHandlers.append(subscription)
    return subscription
  }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
  weak var target: T?
  let handler: (T) -> (U) -> ()
  let event: Event<U>

  init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
  {
    self.target = target
    self.handler = handler
    self.event = event
  }

  func invoke(_ data: Any) {
    if let t = target {
      handler(t)(data as! U)
    }
  }

  func dispose()
  {
    event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
  }
}

class Game
{
  var ratEnters = Event<AnyObject>()
  var ratDies   = Event<AnyObject>()
  var notifyRat = Event<(AnyObject,Rat)>()

  func fireRatEnters(_ sender: AnyObject)
  {
    ratEnters.raise(sender)
  }

  func fireRatDies(_ sender: AnyObject)
  {
    ratDies.raise(sender)
  }

  func fireNotifyRat(_ sender: AnyObject, _ whichRat: Rat)
  {
    notifyRat.raise(sender, whichRat)
  }
}

class Rat
{
  private let game: Game
  var attack = 1

  init(_ game: Game)
  {
        self.game = game

    game.ratEnters.addHandler(
      target: self,
      handler: {
        (_) -> ((AnyObject)) -> () in
        return {
          if $0 !== self
          {
            self.attack += 1
            game.fireNotifyRat(self, $0 as! Rat)
          }
        }
      }
    )

    game.ratDies.addHandler(
      target: self,
      handler: {
        (_) -> ((AnyObject)) -> () in
        return {
          if $0 !== self
          {
            self.attack -= 1
          }
        }
      }
    )

    game.notifyRat.addHandler(
      target: self,
      handler: {
        (_) -> ((AnyObject, Rat)) -> () in
        return {
          if $1 === self
          {
            self.attack += 1
          }
        }
      }
    )

    game.fireRatEnters(self)
  }

  func kill() {
    game.fireRatDies(self)
  }
}
```
<br></br>
Observer summary
- Observer is an intrusive approach: an observable must provide an event to subscribe to
- Special care must be taken to prevent issues in multithreaded scenarios
- Observer/Observable concepts are used in stream processing(Reactive Extensions)
<br></br>
###   3-9. State
    - Consider an ordinary telephone
    - What you do with it depends on the state of the phone/line
      - If it's ringing or you want to make a call, you can pick up
      - Phone must be off the hook to talk/make a call
      - If you try calling someone, and it's busy, you put the handset down
    - Changes in state can be explicit or in response to event(Observer pattern)
    - A pattern in which the object's behavior is determined by its state. An object ransitions from one state to another(something needs to trigger a transition).
    - A formalized construct which manages state and transitions is called a state machine
<br></br>
State sample code
```swift
import Foundation
import XCTest

class CombinationLock
{
  private let combination: [Int]
  var status = ""
  private var digitsEntered = 0
  private var failed = false

  init(_ combination: [Int])
  {
    self.combination = combination
    reset()
  }

  private func reset()
  {
    status = "LOCKED"
    digitsEntered = 0
    failed = false
  }

  func enterDigit(_ digit: Int)
  {
    if (status == "LOCKED") { 
      status = "" 
    }
    status += String(digit)
    if combination[digitsEntered] != digit
    {
      failed = true
    }
    digitsEntered += 1

    if digitsEntered == combination.count
    {
      status = (failed ? "ERROR" : "OPEN")
    }
  }
}
```
<br></br>
State summary
- Give sufficient complexity, it pays to formally define possible states and events/triggers
- Can define
  - State entry/exit behaviors
  - Action when a particular event causes a transition
  - Guard conditions enabling/disabling a transition
<br></br>
###   3-10. Strategy
    - Many algorithms can be decomposed into higher-and lower-level parts
    - Making tea can be decomposed into
      - The process of making a hot beverage(boil water, pour into cup); and
      - Tea-specific things(put teabag into water)
    - The high-level algorithm can then be reused for making coffee or hot chocolate
      - Supported by beverage-specific strategies
    - Enables the exact behavior of a system to be selected either at run-time(dynamic) or compile-time(static)
    - Also known as a policy(esp. in the C++ world).
<br></br>
Strategy sample code
```swift
import Foundation
import XCTest

protocol DiscriminantStrategy
{
  func calculateDiscriminant(_ a: Double, _ b: Double, _ c: Double) -> Double
}

class OrdinaryDiscriminantStrategy : DiscriminantStrategy
{
  func calculateDiscriminant(_ a: Double, _ b: Double, _ c: Double) -> Double
  {
    return b*b - 4*a*c
  }
}

class RealDiscriminantStrategy : DiscriminantStrategy
{
  func calculateDiscriminant(_ a: Double, _ b: Double, _ c: Double) -> Double
  {
    let result = b*b - 4*a*c
    return (result >= 0) ? result : Double.nan
  }
}

class QuadraticEquationSolver
{
  private let strategy: DiscriminantStrategy

  init(_ strategy: DiscriminantStrategy)
  {
    self.strategy = strategy
  }

  func solve(_ a: Double, _ b: Double, _ c: Double) -> (Double, Double)
  {
    let disc = strategy.calculateDiscriminant(a, b, c)
    let rootDisc = sqrt(disc)
    return ((-b + rootDisc) / (2*a), (-b - rootDisc) / (2*a))
  }
}
```
<br></br>
Strategy summary
- Define an algorith at a high level
- Define the interface you expect each strategy to follow
- Provide for either dynamic or static composition of strategy in the overall algorithm
<br></br>
###   3-11. Template Method
    - Algorithms can be decomposed into common parts + specifics
    - Strategy pattern does this through composition
      - High-level algorithm uses an interface
      - Concrete implementations implement the interface
    - Template Method does the same thing through inheritance
      - Overall algorithm makes use of abstract member
      - Inheritors override the abstract members
      - Parent template method invoked
    - Allows us to define the 'skeleton' of the algorithm, which concrete implementations defined in subclasses.
<br></br>
Template sample code
```swift
class Creature
{
  public var attack, health: Int

  init(_ attack: Int, _ health: Int)
  {
    self.attack = attack
    self.health = health
  }
}

class CardGame
{
  var creatures: [Creature]

  init(_ creatures: [Creature])
  {
    self.creatures = creatures
  }

  // the arguments creature1 and creature2 are indices in the 'creatures array'
  //
  // method returns the index of the creature that won the fight
  // returns -1 if there is no clear winner (both alive or both dead)
  func combat(_ creature1: Int, _ creature2: Int) -> Int
  {
    let first = creatures[creature1]
    let second = creatures[creature2]
    hit(first, second)
    hit(second, first)
    let firstAlive = (first.health > 0)
    let secondAlive = (second.health > 0)
    if firstAlive == secondAlive
    {
      return -1
    }
    return firstAlive ? creature1 : creature2
  }

  internal func hit(_ attacker: Creature, _ other: Creature)
  {
    precondition(false, "this method needs to be overridden")
  }
}

class TemporaryCardDamageGame : CardGame
{
  override func hit(_ attacker: Creature, _ other: Creature)
  {
    let oldHealth = other.health
    other.health -= attacker.attack
    if other.health > 0
    {
      other.health = oldHealth
    }
  }
}

class PermanentCardDamage : CardGame
{
  override func hit(_ attacker: Creature, _ other: Creature)
  {
    other.health -= attacker.attack
  }
}
```
<br></br>
Template summary
- Define an algorithm at a high level
- Define constituent parts as abstract methods/properties
- Inherit the algorithm class, providing necessary overrides
<br></br>
###   3-12. Visitor
    - Need to define a new operation on an entire class hierarchy
      - E.g., make a document model printable to HTML/Markdown
    - Do not want to keep modifying every class in the hierarchy
    - Need access to the non-common aspects of classes in the hierarchy
      - I.e., an extension method won't do
    - Create an external component to handle rendering
      - But avoid type checks
    - Visitor
      - A pattern where a component(visitor) is allowed to traverse the entire inheritance hierarchy. Implemented by propagating a single visit() method throughout the entire hierarchy.
    - Dispatch
      - Which function to call?
      - Single dispatch: depends on name of request and type of receiver
      - Double dispatch: depends on name of request and type of two receivers(Type of visitor, type of element being visited)
<br></br>
Visitor sample code
```swift
import Foundation
import XCTest

protocol ExpressionVisitor
{
  func accept(_ value: Value)
  func accept(_ ae: AdditionExpression)
  func accept(_ me: MultiplicationExpression)
}

protocol Expression
{
  func visit(_ ev: ExpressionVisitor)
}

class Value : Expression
{
  let value: Int
  init(_ value: Int)
  {
    self.value = value
  }
  func visit(_ ev: ExpressionVisitor)
  {
    ev.accept(self)
  }
}

class AdditionExpression : Expression
{
  let lhs, rhs: Expression
  init(_ lhs: Expression, _ rhs: Expression)
  {
    self.lhs = lhs
    self.rhs = rhs
  }
  func visit(_ ev: ExpressionVisitor)
  {
    ev.accept(self)
  }
}

class MultiplicationExpression : Expression
{
  let lhs, rhs: Expression
  init(_ lhs: Expression, _ rhs: Expression)
  {
    self.lhs = lhs
    self.rhs = rhs
  }
  func visit(_ ev: ExpressionVisitor)
  {
    ev.accept(self)
  }
}

class ExpressionPrinter :
  ExpressionVisitor, CustomStringConvertible
{
  private var buffer = ""

  func accept(_ value: Value)
  {
    buffer.append(String(value.value))
  }

  func accept(_ ae: AdditionExpression)
  {
    buffer.append("(")
    ae.lhs.visit(self)
    buffer.append("+")
    ae.rhs.visit(self)
    buffer.append(")")
  }

  func accept(_ me: MultiplicationExpression)
  {
    me.lhs.visit(self)
    buffer.append("*")
    me.rhs.visit(self)
  }

  var description: String
  {
    return buffer
  }
}
```
<br></br>
Visitor summary
- Propagate an accept(v: Visitor) method troughout the entire hierarchy
- Create a visitor with visit(:Foo), Visit(:Bar), ... for each element in the hierarchy
- Each accept() simply calls visitor.visit(self)
<br></br>
<br></br>
## Creational Patterns Summary
- Builder
  - Separate component for when object  construction gets too complicated
  - Can create mutually cooperating sub-builders
  - Often has a fluent interface
- Factories
  - Factory method more expressive than initializer
  - Factory can be an outside class or inner class; inner class has the benefit of accessing private members
- Prototype
  - Creation of object from an existing object
  - Requires either explicit copying initializer or deep copy method
- Singleton
  - When you need to ensure jus a single instance exists
  - Direct dependencies on a singleton are difficult to test(also difficult to refactor)
  - Consider extracting interface or using dependency injection
<br></br>
## Structural Pattrens Summary
- Adapter
  - Converts the interface you get to the interface you need
- Bridge
  - Decouple abstraction from implementation
- Composite
  - Allows clients to treat individual objects and compostions of objects uniformly
- Decorator
  - Attach additional responsibilities to objects
  - 'Inherit' from final classes or value types; emulate mutiple inheritance
- Facade
  - Provide a single unified interface over a set of interfaces
- Flyweight
  - Space saving technique
  - Efficiently support very large numbers of similar objects
- Proxy
  - Provide a surrogate object that forwards calls to the real object while performing additional functions
  - E.g., access control, communication, logging, etc. 
<br></br>
## Behavioral Pattrens Summary
- Chain of Responsibility
  - Allow components to process information/events in a chain
  - Each element in the chain refers to next element; or
  - Make a list and go trough it
- Command
  - Encapsulate a request into a separate object
  - Good for audit, replay, undo/redo
  - Part of CQS/CQRS(Qurey is also, effectively, a command)
- Interpreter
  - Transform textual input into object-oriented structures
  - Used by interpreters, compilers, static analytics tools, etc.
  - Compiler Theory is a separate branch of Computer Science
- Iterator
  - Provides an interface for accessing elements of an aggregate object
  - Typically used implicitly via for..in..
- Mediator
  - Provides mediation services between objects
  - Objects not necessarily aware of each other's presence
  - E.g., message passing, chat room
- Memento
  - Yields tokens representing system states
  - Tokens do not allow direct manipulation, but can be used in appropriate APIs
- Observer
  - Allows notification of listening components
  - Uses the concept of an event
  - Property observers built into the language
- State
  - We model systems by having one of a possible states and transitions between these states
  - Such a system is called a state machine
  - Special frameworks exist to orchestrate state machines
- Strategy
  - 'Outsource' part of an algorithm into separate implementations
  - Can be selected at compile or runtime
- Template Method
  - Define the outline of the algorithm with details filled in by inheritors
 - Visitor
  - Enable type-safe traversal of data structures
  - 'Double dispatch' requires each member of hierarchy to accept a visitor
