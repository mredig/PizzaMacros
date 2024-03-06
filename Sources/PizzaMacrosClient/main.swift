import PizzaMacros
import Foundation


let newURL = #URL("http://")
print(newURL)


struct Foo {
	var value: Int

	var secondValue: String
}

struct Bar {
	var foo: Foo

	@PropertyForwarder(parentProperty: \Bar.foo, forwardedProperty: \Foo.value)
	var value: Int

	@PropertyForwarder(parentProperty: \Bar.foo, forwardedProperty: \.secondValue)
	var secondValue: String
}
