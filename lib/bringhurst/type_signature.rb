module Bringhurst
  class TypeSignature
    attr_reader :klass, :method, :method_kind, :arguments, :result

    def initialize(klass:, method:, method_kind:, arguments:, result:)
      @klass = klass
      @method = method
      @method_kind = method_kind
      @arguments = arguments
      @result = result
    end

    def ==(other)
      self.class == other.class &&
        klass == other.klass &&
        method == other.method &&
        method_kind == other.method_kind &&
        arguments == other.arguments &&
        result == other.result
    end

    def to_s
      "#{ method_name }: #{ (arguments + [result]).map(&:to_s).join(" -> ") }"
    end

    private

    def method_name
      if method_kind == :instance
        "#{ klass }##{ method }"
      elsif method_kind == :class
        "#{ klass }.#{ method }"
      end
    end
  end
end
