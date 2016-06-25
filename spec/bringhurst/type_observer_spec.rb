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

  describe "#observe_instance_method" do
    it "notices when registered instance methods are called" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_method,
        method_kind: :instance,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      observer.observe_instance_method(TestClass, :test_method)
      TestClass.new.test_method(2, 3)

      expect(observer.method_calls).to include(result)
    end

    it "doesn't notice when unregistered instance methods in the same class are called" do
      observer = Bringhurst::TypeObserver.new

      observer.observe_instance_method(TestClass, :test_method)
      TestClass.new.test_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls.map(&:method)).not_to include(:test_method_wth_block)
    end

    it "notices when registered instance methods are called with blocks" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_method_with_block,
        method_kind: :instance,
        arguments: [Fixnum, Fixnum, Proc],
        result: Fixnum,
      )

      observer.observe_instance_method(TestClass, :test_method_with_block)
      TestClass.new.test_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls).to include(result)
    end

    it "doesn't notice when unregistered class methods in the same class are called" do
      observer = Bringhurst::TypeObserver.new

      observer.observe_class_method(TestClass, :test_class_method)
      TestClass.test_class_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls.map(&:method)).
        not_to include(:test_class_method_wth_block)
    end
  end

  describe "#observe_class_method" do
    it "notices when registered class methods are called" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_class_method,
        method_kind: :class,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      observer.observe_class_method(TestClass, :test_class_method)
      TestClass.test_class_method(2, 3)

      expect(observer.method_calls).to include(result)
    end

    it "notices when registered class methods are called with blocks" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_class_method_with_block,
        method_kind: :class,
        arguments: [Fixnum, Fixnum, Proc],
        result: Fixnum,
      )

      observer.observe_class_method(TestClass, :test_class_method_with_block)
      TestClass.test_class_method_with_block(2, 3) { |a, b| a + b }

      expect(observer.method_calls).to include(result)
    end
  end

  describe "#observe_class" do
    it "notices when instance methods in registered classes are called" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_method,
        method_kind: :instance,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      observer.observe_class(TestClass)
      TestClass.new.test_method(2, 3)

      expect(observer.method_calls).to include(result)
    end

    it "notices when class methods in registered classes are called" do
      observer = Bringhurst::TypeObserver.new
      result = Bringhurst::TypeSignature.new(
        klass: TestClass,
        method: :test_class_method,
        method_kind: :class,
        arguments: [Fixnum, Fixnum],
        result: Fixnum,
      )

      observer.observe_class(TestClass)
      TestClass.test_class_method(2, 3)

      expect(observer.method_calls).to include(result)
    end
  end
end
