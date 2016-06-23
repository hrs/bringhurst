module Bringhurst
  class Formatter
    def initialize(signatures)
      @signatures = signatures
    end

    def to_s
      "\n" +
        "Observed Type Signatures\n" +
        "========================\n" +
        signatures.map(&:to_s).uniq.sort.join("\n")
    end

    private

    attr_reader :signatures
  end
end
