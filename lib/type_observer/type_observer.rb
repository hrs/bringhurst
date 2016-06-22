require "securerandom"
require "singleton"

module TypeObserver
  class Observer
    include Singleton

    attr_reader :method_calls

    def initialize
      @method_calls = []
    end

    def observe_class(klass)
      wrap_instance_methods_of(klass)
      wrap_class_methods_of(klass)
    end

    def register_call(signature)
      @method_calls << signature
    end

    private

    def wrap_instance_methods_of(klass)
      instance_methods_of(klass).each do |method_name|
        wrap_instance_method(klass, method_name)
      end
    end

    def instance_methods_of(klass)
      klass.instance_methods(false)
    end

    def wrap_instance_method(klass, method_name)
      aliased_method_name = generate_aliased_method_name_for(method_name)

      klass.class_eval do
        alias_method(aliased_method_name, method_name)

        define_method(method_name) do |*args|
          TypeObserver::Observer.instance.register_call(
            "#{ klass }##{ method_name }",
          )

          public_send(aliased_method_name, *args)
        end
      end
    end

    def wrap_class_methods_of(klass)
      class_methods_of(klass).each do |method_name|
        wrap_class_method(klass, method_name)
      end
    end

    def wrap_class_method(klass, method_name)
      aliased_method_name = generate_aliased_method_name_for(method_name)

      klass.class_eval do
        singleton_class.send(
          :alias_method,
          aliased_method_name,
          method_name,
        )

        define_singleton_method(method_name) do |*args|
          TypeObserver::Observer.instance.register_call(
            "#{ klass }.#{ method_name }",
          )

          public_send(aliased_method_name, *args)
        end
      end
    end

    def class_methods_of(klass)
      klass.methods(false)
    end

    def generate_aliased_method_name_for(method_name)
      "#{ method_name }_#{ SecureRandom.uuid }"
    end
  end
end
