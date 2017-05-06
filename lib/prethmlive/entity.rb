require 'memoizable'

module Prethmlive
  class Entity
    include Memoizable

    attr_reader :attributes

    alias_method :to_h, :attributes

    class << self
      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      def object_attr_reader(klass, key1)
        define_attribute_method(key1, klass)
        define_predicate_method(key1)
      end

      def objects_attr_reader(klass, key1)
        define_array_attribute_method(key1, klass)
        define_predicate_method(key1)
      end

      private

      def define_attribute_method(key1, klass = nil)
        define_method(key1) do
          attr_val = @attributes[key1]
          return attr_val if klass.nil?

          klass.new(attr_val)
        end
        memoize(key1)
      end

      def define_array_attribute_method(key1, klass)
        define_method(key1) do
          (@attributes[key1] || []).map { |attrs|
            klass.new(attrs)
          }
        end
      end

      def define_predicate_method(key1)
        method_name = :"#{key1}?"
        define_method(method_name) do
          val = @attributes[key1]
          return !val.empty? if val.respond_to?(:empty?)
          return val.positive? if val.is_a?(Integer)

          !!val
        end
        memoize(method_name)
      end
    end

    def initialize(attributes = {})
      @attributes = (attributes || {}).with_indifferent_access
    end
  end
end