#require 'test_helper'
require 'minitest/autorun'
require 'fast-units'
#require 'ruby-units'

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

  it "can compare two units" do
    assert Unit("1.1 ml") > Unit("1 ml")
  end

  it "can check compatibility" do
    c = Unit("1 mg").compatible? Unit("2 mg")
    assert_equal true, c
  end

  it "can check compatibility" do
    c = Unit("1 mg").compatible? Unit("2 ml")
    assert_equal false, c
  end

  it "can check complicated compatibility" do
    c = Unit("1 mg/ml").compatible? Unit("2 ml")
    assert_equal false, c
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

  it "layered units are compatible " do
    unit = Unit("10 mg") / Unit("1 ml") / Unit("1 ml")
    c = unit.compatible? Unit('ml')
    assert_equal false, c
  end

  it "can multiply on layered units" do
    unit_1 = Unit("10 mg") / Unit("1 ml") / Unit("1 ml")
    unit_2 = Unit('ml')
    result = unit_1 * unit_2
    assert_equal Unit('10 mg/ml'), result
  end

  it "can convert to a string" do
    unit = Unit("10 mg/ml")
    assert_equal "10 mg/ml", unit.to_s
  end

  it "cannot add a mg to a ml" do
    #assert_raise TypeError do
    begin
      total = Unit("1 mg") + Unit("1 ml")
    rescue ArgumentError
      assert true
    else
      assert false
    end
  end

end