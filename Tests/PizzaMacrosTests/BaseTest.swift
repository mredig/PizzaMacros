import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros

class BaseTest: XCTestCase {
    static let testMacros: [String: Macro.Type] = [
        "URL": URLMacro.self,
        "Data": DataBase64Macro.self,
        "String": StringBase64Macro.self,
        "PropertyForwarder": PropertyForwarderParentPropertyMacro.self,
        "PropertyForwarder2": PropertyForwarderPrecisePropertyMacro.self,
    ]
}
#endif
