require "spec_helper"

describe Bringhurst::TypeSignature do
  describe "#==" do
    it "returns true if all attributes are equal" do
      sig_a = Bringhurst::TypeSignature.new(
        method: "foo",
        arguments: [Fixnum],
        result: Fixnum,
      )
      sig_b = Bringhurst::TypeSignature.new(
        method: "foo",
        arguments: [Fixnum],
        result: Fixnum,
      )

      expect(sig_a).to eq(sig_b)
    end
  end

  describe "#to_s" do
    it "formats the signature in a Haskell-y style" do
      signature = Bringhurst::TypeSignature.new(
        method: "SomeClass#foo",
        arguments: [Fixnum, String],
        result: Fixnum,
      )

      expect(signature.to_s).to eq("SomeClass#foo: Fixnum -> String -> Fixnum")
    end
  end
end
