require "fast-units/version"
require 'set'

module FastUnits
  class Unit < Numeric
#    attr_accessor :scalar, :units

    def initialize(desc)
      pieces = desc.split(" ")
      if pieces.length == 2
        scalar, units = pieces
      else
        scalar = 1
        units = pieces[0]
      end
      @_units = FastUnits::Uom.new(units)
      @_scalar = Rational(scalar)
      return self
    end

    def scalar
      @_scalar.denominator == 1 ? @_scalar.to_i : @_scalar

    end

    def units
      @_units.to_s
    end

    def +(other)
      if other.class != FastUnits::Unit
        raise TypeError, other.class + ' cannot be added to a Unit'
      end
      compatible! other.units, self.units
      FastUnits::Unit.new((@_scalar + other.scalar).to_s + " " +@_units.to_s)
    end

    def -(other)
      if other.class != FastUnits::Unit
        raise TypeError, other.class + ' cannot be subtracted from a Unit'
      end
      compatible! other.units, self.units
      FastUnits::Unit.new((@_scalar - other.scalar).to_s + " " +@_units.to_s)
    end

    def *(other)
      scalar = @_scalar * other.scalar
      units = @_units * FastUnits::Uom.new(other.units)
      units.simplify
      FastUnits::Unit.new(scalar.to_s + " " + units.to_s)
    end

    def /(other)
      scalar = @_scalar / other.scalar
      units = @_units / FastUnits::Uom.new(other.units)
      units.simplify
      FastUnits::Unit.new(scalar.to_s + " " + units.to_s)
    end

    def <=>(other)
      compatible! other.units, @units
      return @_scalar <=> other.scalar
    end

    def to_s
      
      "%s %s" % [scalar, units]
    end

    def compatible?(other)
      begin
        if other.class != FastUnits::Unit
          raise ArgumentError, other.class + ' is not a Unit'
        end
        compatible! other.units, units
      rescue
        false
      end
    end

    def compatible!(units1, units2)
      if units1 != units2
        raise ArgumentError, units1 + ' is not compatible with ' + units2
      end
      true
    end
  end

  class Uom
    attr_accessor :num, :denom

    def initialize(text)
      if text != ''
        @num, @denom = parse_units(text)
      else
        @num, @denom = [],[]
      end
    end
    
    def parse_units(text)
      pieces = text.split("/")
      if pieces.length > 1
        [pieces[0].split('*'), pieces[1..-1]]
      elsif pieces.length > 0
        [[pieces[0]], []]
      else
        [[],[]]
      end
    end

    def condense(list)
      set = Set.new list
      built_list = set.map do |u|
        c = list.count(u)
        if c == 1
          u
        else
          u + '^' + c.to_s
        end
      end
      built_list
    end

    def to_s
      text = condense(@num).join('*')
      if @denom.length > 0
        text += '/' + condense(@denom).join('/')
      end
      text
    end

    def *(other_uom)
      u = FastUnits::Uom.new('')
      u.num = @num + other_uom.num
      u.denom = @denom + other_uom.denom
      u.simplify
      u
    end

    def /(other_uom)
      u = FastUnits::Uom.new('')
      u.num = @num + other_uom.denom
      u.denom = @denom + other_uom.num
      u.simplify
      u
    end

    def simplify
      num_copy = @num
      num_copy.each do |u|
        index = @denom.index u
        if index
          @num.delete_at @num.index(u)
          @denom.delete_at index
        end
      end
    end
  end
end

def Unit(args)
  FastUnits::Unit.new(args)
end