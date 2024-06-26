import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PizzaMacrosPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		URLMacro.self,
		DataBase64Macro.self,
		StringBase64Macro.self,
		PropertyForwarderParentPropertyMacro.self,
		PropertyForwarderPrecisePropertyMacro.self,
		BitshiftLiteralMacro.self,
	]
}
