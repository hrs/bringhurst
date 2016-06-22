module Bringhurst
  class TypeSignature
    attr_reader :method, :arguments, :result

    def initialize(method:, arguments:, result:)
      @method = method
      @arguments = arguments
      @result = result
    end

    def ==(other)
      self.class == other.class &&
        method == other.method &&
        arguments == other.arguments &&
        result == other.result
    end

    def to_s
      "#{ method }: #{ (arguments + [result]).map(&:to_s).join(" -> ") }"
    end
  end
end
