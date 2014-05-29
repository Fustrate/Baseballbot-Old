module Baseballbot
  module Template
    class Base
      def initialize(template:)
        @template = template
      end

      def inspect
        %Q(#<#{self.class} @template=#{@template.filename.inspect}>)
      end

      def result
        @template.result binding
      end
    end
  end
end
