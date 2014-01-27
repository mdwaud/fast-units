require "fast-units/version"

module FastUnits
  class Unit < Numeric
    attr_accessor :scalar, :units

    def initialize(desc)
      scalar, @units = desc.split(" ")
      @scalar = Rational(scalar)
      return self
    end

    def +(other)
      if other.class != FastUnits::Unit
        raise TypeError, other.class + ' cannot be added to a Unit'
      end
      compatible! other.units, self.units
      FastUnits::Unit.new((@scalar + other.scalar).to_s + " " +@units)
    end

    def -(other)
      if other.class != FastUnits::Unit
        raise TypeError, other.class + ' cannot be subtracted from a Unit'
      end
      compatible! other.units, self.units
      FastUnits::Unit.new((@scalar - other.scalar).to_s + " " +@units)
    end

    def *(other)
      num, denom = @units.split("/")
      compatible! other.units, denom
      FastUnits::Unit.new((@scalar * other.scalar).to_s + " " +num)
    end

    def /(other)
      new_scalar = @scalar / other.scalar
      new_units = @units + "/" + other.units
      FastUnits::Unit.new(new_scalar.to_s + " " + new_units)
    end

    def <=>(other)
      compatible! other.units, @units
      return @scalar <=> other.scalar
    end

    def compatible?(other)
      if other.class != FastUnits::Unit
        raise TypeError, other.class + ' is not a Unit'
      end
      begin
        compatible! other.units, @units
      rescue
        false
      end
    end

    def compatible!(units1, units2)
      if units1 != units2
        raise TypeError, units1 + ' is not compatible with ' + units2
      end
      true
    end
  end
end

def Unit(args)
  FastUnits::Unit.new(args)
end