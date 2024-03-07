import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros

let testMacros: [String: Macro.Type] = [
	"URL": URLMacro.self,
	"Data": DataBase64Macro.self,
	"String": StringBase64Macro.self,
	"PropertyForwarder": PropertyForwarderPropertyMacro.self,
]

final class PizzaMacrosTests: XCTestCase {
	func testURLMacro() throws {
		assertMacroExpansion(
			#"""
			#URL("https://google.com")
			"""#,
			expandedSource: """
			URL(string: "https://google.com")!
			""",
			macros: testMacros)
	}

	func testDataBase64Macro() throws {
		assertMacroExpansion(
			#"""
			#Data(base64Encoded: "Zm9vYmFy")
			"""#,
			expandedSource: """
			Data(base64Encoded: "Zm9vYmFy")!
			""",
			macros: testMacros)
	}

	func testStringBase64Macro() throws {
		assertMacroExpansion(
			#"""
			#String(base64Encoded: "Zm9vYmFy")
			"""#,
			expandedSource: """
			String(data: Data(base64Encoded: "Zm9vYmFy")!, encoding: .utf8)!
			""",
			macros: testMacros)
	}

    func testPropertyForwarderMacro() throws {
        assertMacroExpansion(
            """
            struct Foo {
                var value: Int
                var secondValue: String
            }

            struct Bar {
                var foo: Foo

                @PropertyForwarder(parentProperty: \\Bar.foo, forwardedProperty: \\Foo.value)
                var value: Int
            }
            """,
        expandedSource:
            """
            struct Foo {
                var value: Int
                var secondValue: String
            }

            struct Bar {
                var foo: Foo
                var value: Int {
                    get {
                        self.foo.value
                    }
                    set {
                        self.foo.value = newValue
                    }
                }
            }
            """,
        macros: testMacros)
    }

    func testPropertyForwarderMacroImplicit() throws {
        assertMacroExpansion(
            """
            struct Foo {
                var value: Int
                var secondValue: String
            }

            struct Bar {
                var foo: Foo

                @PropertyForwarder(parentProperty: \\Bar.foo)
                var value: Int
            }
            """,
        expandedSource:
            """
            struct Foo {
                var value: Int
                var secondValue: String
            }

            struct Bar {
                var foo: Foo
                var value: Int {
                    get {
                        self.foo.value
                    }
                    set {
                        self.foo.value = newValue
                    }
                }
            }
            """,
        macros: testMacros)
    }

    func testPropertyForwarderMacroInception() throws {
        assertMacroExpansion(
            #"""
            struct Foo {
                var value: Int

                var secondValue: String

                var embeddedValue: Bool
            }

            struct Bar {
                var mahFoo: Foo
            }

            struct Baz {
                var foo: Foo
                var bar: Bar

                @PropertyForwarder(parentProperty: \Baz.foo, forwardedProperty: \Foo.value)
                var value: Int

                @PropertyForwarder(parentProperty: \Baz.foo)
                var secondValue: String

                @PropertyForwarder(parentProperty: \Baz.bar.mahFoo)
                var embeddedValue: Bool
            }
            """#,
        expandedSource:
            #"""
            struct Foo {
                var value: Int

                var secondValue: String

                var embeddedValue: Bool
            }

            struct Bar {
                var mahFoo: Foo
            }

            struct Baz {
                var foo: Foo
                var bar: Bar
                var value: Int {
                    get {
                        self.foo.value
                    }
                    set {
                        self.foo.value = newValue
                    }
                }
                var secondValue: String {
                    get {
                        self.foo.secondValue
                    }
                    set {
                        self.foo.secondValue = newValue
                    }
                }
                var embeddedValue: Bool {
                    get {
                        self.bar.mahFoo.embeddedValue
                    }
                    set {
                        self.bar.mahFoo.embeddedValue = newValue
                    }
                }
            }
            """#,
        macros: testMacros)
    }
}
#endif
