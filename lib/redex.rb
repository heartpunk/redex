require "redex/version"

module Redex
  Configuration = Struct.new :code, :environment

  class Hole # this should include iso-init prolly
    attr_accessor :expression
    def initialize expr
      self.expression = expr
    end
  end

  class Interpreter
    attr_accessor :history, :selector, :reducer
    def initialize configuration, selector, reducer
      self.selector = selector
      self.reducer = reducer
      self.history = [configuration]
    end

    def run
      tick until finished
    end

    def tick
      update_configuration(reducer.call(selector.call(configuration)))
    end

    def configuration
      history[-1]
    end

    private

    def update_configuration config
      history << (config.dup.freeze rescue config) # idiom stolen shamelessly from https://github.com/yaauie/iso-init
    end

    def finished
      selector.call(configuration).size == 0
    end
  end

  class SexpArithmeticInterpreter < Interpreter
    def deep_check array, &blk
      array.map do |el|
        if el.is_a?(Array)
          blk.call(el) or deepmap(el, &blk)
        else
          blk.call(el)
        end
      end
    end
    def reducible input
      input.is_a? Array
    end
    def terminal input
      input.is_a? Fixnum or input.is_a? Symbol
    end
    def immediately_reducible input
      reducible(input) and input.all? {|el| terminal el}
    end
    SELECTOR = Proc.new do |config|
      deep_check config.code {|e| Hole.new(e) if immediately_reducible(e)}
    end
    REDUCER = Proc.new do |config|
      deep_check config.code do |e|
        if e.is_a? Hole
          
        end
      end
    end
    def initialize expression
      super(Configuration.new(expression, nil), SELECTOR, REDUCER)
    end
  end
end
