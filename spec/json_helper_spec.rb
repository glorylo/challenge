require_relative "../lib/challenge/json_helper"
include Challenge::JsonHelper

describe Challenge::JsonHelper, "#indiff_access" do
  context "Access an object via symbol or string" do
    it "return attribute value when a valid symbol is provided " do
      obj = { a: "some value" }
      actual = indiff_access obj, :a
      expect(actual).to eq "some value"
    end

    it "return attribute value when a valid string equivalent is provided" do
      obj = { a: "some value" }
      actual = indiff_access obj, "a"
      expect(actual).to eq "some value"
    end

    it "return attribute value when a valid symbol equivalent is provided" do
      obj = { "a" => "some value" }
      actual = indiff_access obj, :a
      expect(actual).to eq "some value"
    end

    it "return nil when attribute as string or symbol is not found" do
      obj = { a: "some value" }
      actual = indiff_access obj, "b"
      expect(actual).to be nil
    end
  end
end

describe Challenge::JsonHelper, "#require_prop" do
  context "Require property exists for object" do
    it "should not raise error when property exists" do
      obj = { "name" => "Bob" }
      expect { require_prop(obj, "name") }.not_to raise_error(ArgumentError)
    end

    it "should raise error when property exists" do
      obj = { "name" => "Bob" }
      expect { require_prop(obj, "age") }.to raise_error(ArgumentError)
    end
  end
end

describe Challenge::JsonHelper, "#require_prop_as_type" do
  context "Require object's property exists with the correct type for value" do
    it "should not raise error when string property exists" do
      obj = { "name" => "Bob" }
      expect { require_prop_as_type(obj, "name", [String], "string") }.not_to raise_error(ArgumentError)
    end

    it "should raise error when string property exists" do
      obj = { "name" => 23 }
      expect { require_prop_as_type(obj, "name", [String], "string") }.to raise_error(ArgumentError)
    end

    it "should not raise error when integer property exists" do
      obj = { "age" => 23 }
      expect { require_prop_as_type(obj, "age", [Integer], "integer") }.not_to raise_error(ArgumentError)
    end

    it "should raise error when integer property exists" do
      obj = { "age" => true }
      expect { require_prop_as_type(obj, "name", [Integer], "integer") }.to raise_error(ArgumentError)
    end

    it "should not raise error when boolean property exists" do
      obj = { "active_status" => true }
      expect { require_prop_as_type(obj, "active_status", [TrueClass, FalseClass], "boolean") }.not_to raise_error(ArgumentError)
    end

    it "should raise error when integer property exists" do
      obj = { "active_status" => "false" }
      expect { require_prop_as_type(obj, "active_status", [TrueClass, FalseClass], "boolean") }.to raise_error(ArgumentError)
    end
  end
end
