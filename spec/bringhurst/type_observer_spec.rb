require "spec_helper"

describe Bringhurst::TypeObserver do
  class TestClass
    def test_method(a, b)
      a + b
    end

    def self.test_class_method(a, b)
      a + b
    end
  end

  def observer
    Bringhurst::TypeObserver.instance
  end

  before(:all) do
    observer.observe_class(TestClass)
  end

  it "notices when instance methods in registered classes are called" do
    TestClass.new.test_method(2, 3)
    result = Bringhurst::TypeSignature.new(
      klass: TestClass,
      method: :test_method,
      method_kind: :instance,
      arguments: [Fixnum, Fixnum],
      result: Fixnum,
    )

    expect(observer.method_calls).to include(result)
  end

  it "notices when class methods in registered classes are called" do
    TestClass.test_class_method(2, 3)
    result = Bringhurst::TypeSignature.new(
      klass: TestClass,
      method: :test_class_method,
      method_kind: :class,
      arguments: [Fixnum, Fixnum],
      result: Fixnum,
    )

    expect(observer.method_calls).to include(result)
  end
end
