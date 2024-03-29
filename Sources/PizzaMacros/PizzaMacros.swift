import Foundation

@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL = #externalMacro(module: "PizzaMacrosMacros", type: "URLMacro")

@freestanding(expression)
public macro Data(base64Encoded stringLiteral: String) -> Data = #externalMacro(module: "PizzaMacrosMacros", type: "DataBase64Macro")

@freestanding(expression)
public macro String(base64Encoded stringLiteral: String) -> String = #externalMacro(module: "PizzaMacrosMacros", type: "StringBase64Macro")

@attached(accessor)
public macro PropertyForwarder<T, U, V>(parentProperty: KeyPath<T, U>, forwardedProperty: KeyPath<U, V>) = #externalMacro(module: "PizzaMacrosMacros", type: "PropertyForwarderParentPropertyMacro")

@attached(accessor)
public macro PropertyForwarder<T, U>(parentProperty: KeyPath<T, U>) = #externalMacro(module: "PizzaMacrosMacros", type: "PropertyForwarderParentPropertyMacro")

@attached(accessor)
public macro PropertyForwarder<T, U>(forwardedProperty: KeyPath<T, U>) = #externalMacro(module: "PizzaMacrosMacros", type: "PropertyForwarderPrecisePropertyMacro")

@freestanding(expression)
public macro Bitshift(_ bitshiftExpression: Int) -> Int = #externalMacro(module: "PizzaMacrosMacros", type: "BitshiftLiteralMacro")
