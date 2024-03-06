import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct PropertyForwarderPropertyMacro: AccessorMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingAccessorsOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [AccessorDeclSyntax] {
		guard
			let varDecl = declaration.as(VariableDeclSyntax.self),
			let binding = varDecl.bindings.first,
//			let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
			binding.accessorBlock == nil,
//			let type = binding.typeAnnotation?.type,

			case .argumentList(let arguments) = node.arguments,
			arguments.count == 2
		else { return [] }

		let first = arguments.startIndex
		let second = arguments.index(after: first)
		let parentKeypath = arguments[first].expression
		let forwardedKeypath = arguments[second].expression

		return [
			"""
			get { self[keyPath: \(parentKeypath)][keyPath: \(forwardedKeypath)] }
			""",
			"""
			set { self[keyPath: \(parentKeypath)][keyPath: \(forwardedKeypath)] = newValue }
			"""
		]
	}
}
