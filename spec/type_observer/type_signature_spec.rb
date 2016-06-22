require "spec_helper"

describe TypeObserver::TypeSignature do
  describe "#==" do
    it "returns true if all attributes are equal" do
      sig_a = TypeObserver::TypeSignature.new(
        method: "foo",
        arguments: [Fixnum],
        result: Fixnum,
      )
      sig_b = TypeObserver::TypeSignature.new(
        method: "foo",
        arguments: [Fixnum],
        result: Fixnum,
      )

      expect(sig_a).to eq(sig_b)
    end
  end
end
