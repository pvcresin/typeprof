## update: test.rbs
class C
  def foo: (Integer) -> :int
         | (String) -> :str
end

## update: test.rb
class D1 < C
  def foo
    super(1)
  end
end

class D2 < C
  def foo
    super("str")
  end
end

## assert
class D1 < C
  def foo: -> :int
end
class D2 < C
  def foo: -> :str
end

## update
class StringifyKeyHash < Hash
  def [](key)
    super(key.to_s)
  end
end

## assert
class StringifyKeyHash < Hash
  def []: (untyped) -> untyped
end

## update
class SuperBase
  def foo(*a, **b)
    [a, b]
  end
end

class SuperChild < SuperBase
  def foo(...)
    super(...)
  end
end

SuperChild.new.foo(1, x: 4, y: 5)

## assert
class SuperBase
  def foo: (*Integer, **Integer) -> [Array[Integer], { x: Integer, y: Integer }]
end
class SuperChild < SuperBase
  def foo: (*Integer, **Integer) -> [Array[Integer], { x: Integer, y: Integer }]
end

## update
class SuperBase3
  def foo
    1
  end
end

class SuperChild3 < SuperBase3
  def foo(...)
    super(...)
  end
end

SuperChild3.new.foo()

## assert
class SuperBase3
  def foo: -> Integer
end
class SuperChild3 < SuperBase3
  def foo: (*untyped, **untyped) -> Integer
end

## update
class SuperBase2
  def foo(a, *b)
    [a, b]
  end
end

class SuperChild2 < SuperBase2
  def foo(...)
    super(1, ...)
  end
end

SuperChild2.new.foo()

## assert
class SuperBase2
  def foo: (Integer, *untyped) -> [Integer, Array[untyped]]
end
class SuperChild2 < SuperBase2
  def foo: (*untyped, **untyped) -> [Integer, Array[untyped]]
end
