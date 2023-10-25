require_relative '../lib/challenge/json_helper'
include Challenge::JsonHelper

describe Challenge::JsonHelper, '#indiff_access' do
  context 'Access an object via symbol or string' do
    it 'return attribute value when a valid symbol is provided ' do
      obj = { a: "some value" }
      actual = indiff_access obj, :a
      expect(actual).to eq "some value"
    end

    it 'return attribute value when a valid string equivalent is provided' do
      obj = { a: "some value" }
      actual = indiff_access obj, "a"
      expect(actual).to eq "some value"
    end

    it 'return nil when attribute as string or symbol is not found' do
      obj = { a: "some value" }
      actual = indiff_access obj, "b"
      expect(actual).to be nil
    end
  end    
    
end