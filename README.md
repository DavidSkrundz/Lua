Lua [![Swift Version](https://img.shields.io/badge/Swift-3.1-orange.svg)](https://swift.org/download/#releases) [![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg)](https://swift.org/download/#releases) [![Build Status](https://travis-ci.org/DavidSkrundz/Lua.svg?branch=master)](https://travis-ci.org/DavidSkrundz/Lua) [![Codebeat Status](https://codecov.io/gh/DavidSkrundz/Lua/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidSkrundz/Lua) [![Codecov](https://codebeat.co/badges/110e6b2f-aa30-4930-b86f-c9408ecac05e)](https://codebeat.co/projects/github-com-davidskrundz-lua-master)
===

A Swift wraper for Lua 5.2.4

**Not every feature is implemented, and the API is not yet stable**
**Feel free to open a new issue or pull request**

Types
-----

Lua values are wrapped within the `Value` protocol when brought into Swift

###### String
Swift's `String` is used to represent Lua strings

###### Number
The `Number` class represents a numeric value within Lua.  It supports conversion to `Int`, `UInt32`, and `Double` as well as comparisons with those types.

- `.intValue -> Int`
- `.uintValue -> UInt32`
- `.doubleValue -> Double`
- `.isInt -> Bool` true if `.doubleValue` contains no decimal places

###### UnsafeMutablePointer
Swift's `UnsafeMutablePointer` is used to represent Lua lightuserdatas

###### Table
The `Table` class represents a table within Lua.  It supports getting and setting values.

- `subscript(Value) -> Value` get and set values
- `forEach(body: (TableKey, Value) -> Void)` iterate over all key/value pairs in 
- `toDictionary() -> [TableKey : Value]` fetches all of the key/value pairs from the Lua VM and returns a Dictionary

###### Function
The `Function` class represents a Lua closure.  It supports calling with a list of `Value`s

- `call([Value]) -> [Value]` call the function with the arguments

###### CustomType<T>
It is possible to bring Swift types into Lua by creating a `CustomType<T>` which gives access to the new type's metatable and statictable

###### Nil
Represents a nil value on the stack


Typealiases
-----------

- `Index = Int32`
- `Count = Int32`
- `LuaFunction = (Lua) -> [Value]`
- `WrappedFunction = ([Value]) -> [Value]`
- `LuaMethod<T> = (T, Lua) -> [Value]`
- `WrappedMethod<T> = (T, [Value]) -> [Value]`
- `LuaInitializer<T> = (Lua) -> T`
- `WrappedInitializer<T> = ([Value]) -> T`


Usage
-----

### `Lua`

- `Lua()` create a new virtual machine
- `.loadLib([LuaLib])` loads the given standard libraries
- `.globals -> Table` get the global value `Table`
- `run(String) throws -> [Value]` runs a `String` as Lua code
- `push(Value)` pushes a `Value` onto the stack
- `pop() -> Value` pops a `Value` from the stack
- `createTable(Count=0, Count=0) -> Table` creates and returns a new `Table` with optional preallocated space
- `createFunction(LuaFunction) -> Function` creates and returns a new `Function`
- `createFunction([Type],WrappedFunction) -> Function` creates and returns a new `Function` that is typechecked internally
- `createType<T: LuaConvertible>(T.Type) throws -> CustomType<T>` creates a new Lua type from a `LuaConvertible` type and returns its CustomType<T>
- `wrap<T: LuaConvertible>([Type], @escaping WrappedInitializer<T>) -> LuaInitializer<T>` wraps a `WrappedInitializer<T>` to do typechecking internally 
- `wrap<T: LuaConvertible>([Type], @escaping WrappedMethod<T>) -> LuaMethod<T>` wraps a `WrappedMethod<T>` to do typechecking internally
- `wrap([Type], @escaping WrappedFunction) -> LuaFunction` wraps a `WrappedFunction` to do typechecking internally


### `Lua.raw`

- `stackSize() -> Count` returns the number of items on the Lua stack


Future Additions
----------------

- Explicit Garbage Collection
- Rename `CustomType` to `CustomClassType` and implement `CustomStructType` which is a `Table` rather than a `UserData` for simpler types
- Change how `Function` is implemented to allow them to be released without needing to release the entire `Lua` machine
- Complete `LightUserData` implementation
- Expand the capabilities of `CustomType<T>`
- Test `UserData` equality
- Add `Bool` support
- Support for more metamethods
