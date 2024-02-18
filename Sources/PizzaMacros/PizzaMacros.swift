import Foundation

@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL = #externalMacro(module: "PizzaMacrosMacros", type: "URLMacro")

@freestanding(expression)
public macro Data(base64Encoded stringLiteral: String) -> Data = #externalMacro(module: "PizzaMacrosMacros", type: "DataBase64Macro")

