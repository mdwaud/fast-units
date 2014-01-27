#require 'test_helper'
require 'minitest/autorun'
require 'fast-units'

describe 'FastUnits' do
  it "can create a Unit in mg" do
    unit = Unit("1 mg")
    assert_equal 1, unit.scalar
    assert_equal 'mg', unit.units
  end

  it "can create a Unit in ml" do
    unit = Unit("1 ml")
    assert_equal 1, unit.scalar
    assert_equal 'ml', unit.units
  end

  it "can make a Unit from a rational number" do
    unit = Unit("1/10 ml")
    assert_equal Rational("1/10"), unit.scalar
    assert_equal 'ml', unit.units
  end

  it "can add two units in mg" do
    total = Unit("1 mg") + Unit("1 mg")
    assert_equal 2, total.scalar
    assert_equal 'mg', total.units
  end

  it "can add two units in ml" do
    total = Unit("1 ml") + Unit("1 ml")
    assert_equal 2, total.scalar
    assert_equal 'ml', total.units
  end

  it "can subtract two units in mg" do
    total = Unit("1 mg") - Unit("1 mg")
    assert_equal 0, total.scalar
    assert_equal 'mg', total.units
  end

  it "can make concentrations" do
    total = Unit("1 mg") / Unit("10 ml")
    assert_equal Rational("1/10"), total.scalar
    assert_equal 'mg/ml', total.units
  end

  it "can unmake concentrations" do
    total = Unit("10 mg/ml") * Unit("2 ml")
    assert_equal 20, total.scalar
    assert_equal 'mg', total.units
  end

  it "cannot add a mg to a ml" do
    #assert_raise TypeError do
    begin
      total = Unit("1 mg") + Unit("1 ml")
    rescue TypeError
      assert true
    else
      assert false
    end
  end

end