require "uberscore/version"

UBERSCORE_METHOD_NAME = :_ unless defined? UBERSCORE_METHOD_NAME

module Uberscore
  class Context < BasicObject
    class << self
      alias_method :__new_uberscore_context__, :new
      undef_method :new
    end

    undef_method :!
    undef_method :!=
    undef_method :==
    undef_method :__id__

    def initialize
      @call_chain = []
    end

    def method_missing(name, *args, &block)
      @call_chain << [name, args, block]
      self
    end

    def to_proc
      ->(object) do
        @call_chain.reduce(object) do |block_parameter, (method_name, method_arguments, block)|
          method_arguments = method_arguments.map{|a| coerce(a, object)}
          block_parameter.public_send(method_name, *method_arguments, &block)
        end
      end
    end

    private

    def coerce(arg, object)
      Context === arg ? arg.to_proc.call(object) : arg
    end
  end

  Kernel.send(:define_method, UBERSCORE_METHOD_NAME) { Context.__new_uberscore_context__ }
end
