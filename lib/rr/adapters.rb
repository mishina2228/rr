module RR
  module Adapters
    class << self
      DEPRECATED_ADAPTERS = [
        :MiniTest,
        :TestUnit
      ]

      def const_missing(adapter_const_name)
        unless DEPRECATED_ADAPTERS.include?(adapter_const_name)
          super
          return
        end

        show_warning_for(adapter_const_name)

        adapter = case adapter_const_name
          when :TestUnit
            RR.find_applicable_adapter(/^TestUnit/)
          when :MiniTest
            RR.find_applicable_adapter(/^minitest/i)
        end

        if adapter
          shim_adapters[adapter_const_name] ||= RR.module_shim_for_adapter(adapter)
        else
          super
        end
      end

      private

      def shim_adapters
        @shim_adapters ||= {}
      end

      def show_warning_for(adapter_const_name)
        warn <<EOT
--------------------------------------------------------------------------------
RR deprecation warning: RR now has an autohook system. You don't need to
`include RR::Adapters::*` in your test framework's base class anymore.
--------------------------------------------------------------------------------
EOT
      end
    end
  end
end
