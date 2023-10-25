# frozen_string_literal: true

require 'json'
require_relative 'json_helper'
include Challenge::JsonHelper

module Challenge
  # Company is a domain class for encapsulating company info.  Can be instantiated using #load_from_file method
  # or by instantiating it with initialize providing a hash
  class Company
    ATTRIBUTES = %i[id name top_up email_status]
    attr_accessor(*ATTRIBUTES)

    def initialize(args)
      @id = indiff_access args, :id
      @name = indiff_access args, :name
      @top_up = indiff_access args, :top_up
      @email_status = indiff_access args, :email_status
    end

    def self.load_from_file(json_file_path)
      deserialize_array_from_file(json_file_path) do |o|
        validate(o)
        Company.new(o)
      end
    end

    def self.valid?(company)
      return false if company.class != Challenge::Company
      return false if company.id.nil? || !company.id.is_a?(Integer)
      return false if company.name.nil? || !company.name.is_a?(String)
      return false if company.top_up.nil? || !company.top_up.is_a?(Integer)
      return false if company.email_status.nil? || ![TrueClass, FalseClass].include?(company.email_status.class)

      true
    end

    def self.validate(obj)
      require_prop_as_int(obj, 'id')
      require_prop_as_string(obj, 'name')
      require_prop_as_int(obj, 'top_up')
      require_prop_as_bool(obj, 'email_status')
    end
  end
end
