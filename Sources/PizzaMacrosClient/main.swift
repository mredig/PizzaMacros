import PizzaMacros
import Foundation


let newURL = #URL("http://")
print(newURL)


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
