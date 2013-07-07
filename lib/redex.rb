require "redex/version"
require 'pp'

def deep_apply array, &blk
  raise ArgumentError, "no block provided to deep_apply." unless blk
  old_array = (array.dup rescue array)
  maybe_new_array = blk.call(array)
  if maybe_new_array == old_array
    array.map do |el|
      blk.call(el)
    end
  else
    maybe_new_array
  end
end

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
      puts "starting..."
      pp configuration
      tick until finished
    end

    def tick
      puts "selector output:"
      config = selector.call configuration
      pp config
      config = reducer.call config
      puts "reducer output:"
      pp config
      puts ""
      update_configuration config
    end

    def configuration
      history[-1]
    end

    private

    def update_configuration config
      raise "state or code must change, if it doesn't, it means we're stuck." if config == configuration
      history << (config.dup.freeze rescue config) # idiom stolen shamelessly from https://github.com/yaauie/iso-init
    end

    def finished
      self.class.terminal configuration.code
    end
  end

  class SexpArithmeticInterpreter < Interpreter
    def self.reducible input
      input.is_a? Array
    end
    def self.terminal input
      input.is_a? Fixnum or input.is_a? Symbol
    end
    def self.immediately_reducible input
      reducible(input) and input.all? {|el| terminal el}
    end
    SELECTOR = Proc.new do |config|
      code = deep_apply(config.code) {|e| immediately_reducible(e) ? Hole.new(e) : e }
      Configuration.new code, nil
    end
    REDUCER = Proc.new do |config|
      code = deep_apply config.code do |e|
        if e.is_a? Hole
          case e.expression[0]
          when :+ then e.expression[1..-1].inject(0, &:+)
          when :* then e.expression[1..-1].inject(1, &:*)
          end
        else
          e
        end
      end
      Configuration.new code, nil
    end
    def initialize expression
      super(Configuration.new(expression, nil), SELECTOR, REDUCER)
    end
  end
end