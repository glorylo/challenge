# frozen_string_literal: true

require_relative 'json_helper'

include Challenge::JsonHelper
module Challenge
  # User is a domain object to encapsulate user data either deserializing from a file or instantiating it via #new
  class User
    ATTRIBUTES = %i[id first_name last_name email company_id email_status active_status tokens]
    attr_accessor(*ATTRIBUTES)

    def initialize(arg)
      @id = indiff_access arg, :id
      @first_name = indiff_access arg, :first_name
      @last_name = indiff_access arg, :last_name
      @email = indiff_access arg, :email
      @company_id = indiff_access arg, :company_id
      @email_status = indiff_access arg, :email_status
      @active_status = indiff_access arg, :active_status
      @tokens = indiff_access arg, :tokens
    end

    def self.load_from_file(json_file_path)
      deserialize_array_from_file(json_file_path) do |o|
        validate(o)
        User.new(o)
      end
    end

    def self.valid?(user)
      return false if user.class != Challenge::User
      return false if user.id.nil? || !user.id.is_a?(Integer)
      return false if user.first_name.nil? || !user.first_name.is_a?(String)
      return false if user.last_name.nil? || !user.last_name.is_a?(String)
      return false if user.email.nil? || !user.email.is_a?(String)
      return false if user.email_status.nil? || ![TrueClass, FalseClass].include?(user.email_status.class)
      return false if user.active_status.nil? || ![TrueClass, FalseClass].include?(user.active_status.class)
      return false if user.tokens.nil? || !user.tokens.is_a?(Integer)

      true
    end

    def to_h
      ATTRIBUTES.each_with_object({}) do |attribute_name, memo|
        memo[attribute_name] = send(attribute_name)
      end
    end

    def self.validate(obj)
      require_prop_as_int(obj, 'id')
      require_prop_as_string(obj, 'first_name')
      require_prop_as_string(obj, 'last_name')
      require_prop_as_string(obj, 'email')
      require_prop_as_int(obj, 'company_id')
      require_prop_as_bool(obj, 'email_status')
      require_prop_as_bool(obj, 'active_status')
      require_prop_as_int(obj, 'tokens')
    end
  end
end
