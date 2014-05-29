module Baseballbot
  class Gamechat
    def initialize
    end

    def update!
      if id
        update
      else
        post
      end
    end

    protected

    def update
    end

    def post
    end
  end
end
