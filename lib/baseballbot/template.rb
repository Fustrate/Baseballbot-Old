module Baseballbot
  module Template
    refine String do
      def bold
        "**#{self}**"
      end

      def italicize
        "*#{self}*"
      end
    end
  end
end
