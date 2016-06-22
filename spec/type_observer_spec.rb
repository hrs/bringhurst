require "spec_helper"

describe TypeObserver do
  class TestClass
    def test_method(a, b)
      a + b
    end

    def self.test_class_method(a, b)
      a + b
    end
  end

  def observer
    TypeObserver::Observer.instance
  end

  before(:all) do
    observer.observe_class(TestClass)
  end

  it "notices when instance methods in registered classes are called" do
    TestClass.new.test_method(2, 3)
    result = TypeObserver::TypeSignature.new(
      method: "TestClass#test_method",
      arguments: [Fixnum, Fixnum],
      result: Fixnum,
    )

    expect(observer.method_calls).to include(result)
  end

  it "notices when class methods in registered classes are called" do
    TestClass.test_class_method(2, 3)
    result = TypeObserver::TypeSignature.new(
      method: "TestClass.test_class_method",
      arguments: [Fixnum, Fixnum],
      result: Fixnum,
    )

    expect(observer.method_calls).to include(result)
  end
end
