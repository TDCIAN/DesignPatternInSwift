// Interface Segregation Principle
// - Don't put too much into an interface; split into separate interfaces
// - YAGNI - You Ain't Going to Need It
import Foundation

class Document
{

}

protocol Machine 
{
    func print(d: Document)
    func scan(d: Document)
    func fax(d: Document)
}

class MultiFunctionPrinter: Machine
{
    func print(d: Document)
    {

    }

    func scan(d: Document)
    {

    }

    func fax(d: Document)
    {

    }
}

enum NoRequiredFunctionality: Error
{
    case doesNotFax
}

class OldFashionedPrinter: Machine {
    func print(d: Document)
    {

    }
    func fax(d: Document)
    {
        throw NoRequiredFunctionality.doesNotFax
    }
}

protocol Printer
{
    func print(d: Document)
}
protocol Scanner
{
    func scan(d: Document)
}
protocol Fax
{
    func fax(d: Document)
}

class OrdinaryPrinter: Printer
{
    func print(d: Document)
    {
        // ok
    }
}

class PhotoCopier: Printer, Scanner
{
    func print(d: Document)
    {
        // ok
    }
    func scan(d: Document)
    {
        // ok
    }
}

protocol MultiFunctionDevice: Printer, Scanner, Fax
{
    
}

class MultifunctionMachine: MultiFunctionDevice
{
    let printer: Printer
    let scanner: Scanner

    init(printer: Printer, scanner: Scanner)
    {
        self.printer = printer
        self.scanner = scanner
    }

    func print(d: Document)
    {
        // ok
    }
    func scan(d: Document)
    {
        // ok
    }
    func fax(d: Document)
    {
        // ok
    }
}