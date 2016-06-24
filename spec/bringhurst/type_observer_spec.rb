require "spec_helper"

describe Bringhurst::TypeObserver do
  class TestClass
    def test_method(a, b)
      a + b
    end

    def test_method_with_block(a, b)
      yield(a, b)
    end

    def self.test_class_method(a, b)
      a + b
    end

    def self.test_class_method_with_block(a, b)
      yield(a, b)
    end
  end

  def observer
    Bringhurst::TypeObserver.instance
  end

  before(:all) do
    observer.observe_class(TestClass)
  end

  context "when observing instance methods" do
    it "notices when methods in registered classes are called" do
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_method,
        method_kind: :instance,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      TestClass.new.test_method(2, 3)

      expect(observer.method_calls).to include(result)
    end

    it "notices when methods are called with blocks" do
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_method_with_block,
        method_kind: :instance,
        arguments: [Fixnum, Fixnum, Proc],
        result: Fixnum,
      )

      TestClass.new.test_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls).to include(result)
    end
  end

  context "when observing class methods" do
    it "notices when methods in registered classes are called" do
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_class_method,
        method_kind: :class,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      TestClass.test_class_method(2, 3)

      expect(observer.method_calls).to include(result)
    end

    it "notices when methods are called with blocks" do
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_class_method_with_block,
        method_kind: :class,
        arguments: [Fixnum, Fixnum, Proc],
        result: Fixnum,
      )

      TestClass.test_class_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls).to include(result)
    end
  end
end
