# frozen_string_literal: true

require 'json'
module Challenge
  # Helper methods to assist deserialization to classes, accessing of attributes, 
  # json property type validation
  module JsonHelper
    # Loads a json file, if found.  If the json file is not an array of objects, ArgumentError will be raised.
    # If an optional transform block is given, it will do the conversion.
    def deserialize_array_from_file(json_file_path, &block)
      file = File.read(json_file_path)
      data = JSON.parse(file)
      raise ArgumentError, "File #{json_file_path} needs to be an array of objects" unless data.is_a? Array

      return data unless block_given?

      data.map(&block)
    end

    # Takes arg for hash and attempts to access it using the key as a symbol. If it fails it falls back to using the string equivalent.
    def indiff_access(arg, key)
      if key.is_a?(Symbol)
        arg[key].nil? ? arg[key.to_s] : arg[key]
      elsif key.is_a?(String)
        arg[key].nil? ? arg[key.to_sym] : arg[key]
      else
        arg[key]
      end
    end

    def require_prop(obj, prop)
      return if obj.has_key? prop

      raise ArgumentError, "object is missing '#{prop}' for object #{obj}"
    end

    def require_prop_as_type(obj, prop, classes, type)
      require_prop(obj, prop)
      value = obj[prop]
      return if classes.include?(value.class)

      raise ArgumentError, "object '#{obj}' with '#{prop}' has value '#{value}' should be '#{type}'."
    end

    def require_prop_as_bool(obj, prop)
      require_prop_as_type(obj, prop, [TrueClass, FalseClass], 'boolean')
    end

    def require_prop_as_int(obj, prop)
      require_prop_as_type(obj, prop, [Integer], 'integer')
    end

    def require_prop_as_string(obj, prop)
      require_prop_as_type(obj, prop, [String], 'string')
    end
  end
end
