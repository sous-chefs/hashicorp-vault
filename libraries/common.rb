module Vault
  module Cookbook
    module CommonHelpers
      def nil_or_empty?(v)
        v.nil? || (v.respond_to?(:empty?) && v.empty?)
      end

      def array_wrap(obj)
        return obj if obj.is_a?(Array)

        [obj]
      end

      private

      # Hash compact implementation for empties as well as nils
      def compact_hash(hash)
        return unless hash.is_a?(Hash)

        hash.delete_if { |_, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
      end
    end
  end
end
