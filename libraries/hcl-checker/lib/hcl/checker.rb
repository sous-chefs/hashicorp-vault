require_relative 'checker/version'
require_relative 'checker/lexer'
require_relative 'checker/parser'

module HCL
  module Checker
    VALID_DUPLICATE_MODES = %i(array merge).freeze

    class << self
      attr_accessor :last_error

      def valid?(value)
        ret = HCL::Checker::Parser.new.parse(value)
        return true if ret.is_a? Hash

        false
      rescue Racc::ParseError => e
        @last_error = e.message

        false
      end

      def parse(value, duplicate_mode = :array)
        raise ArgumentError, "Invalid duplicate mode #{duplicate_mode}, must be one of #{VALID_DUPLICATE_MODES}" unless VALID_DUPLICATE_MODES.include?(duplicate_mode)

        HCL::Checker::Parser.new.parse(value, duplicate_mode)
      rescue Racc::ParseError => e
        @last_error = e.message

        e.message
      end
    end
  end
end
