require_relative '../spec_helper'

describe NoteInterval do

  it "dorian set should equal a shifted ionian set" do
      NoteInterval.dorian_set.map{|i| i.value}.should ==
      NoteInterval.shift_and_zero_set(NoteInterval.ionian_set).map{|i| i.value}
  end

  it "phrygian mode should equal shifted dorian mode" do
    NoteInterval.phrygian_set.map{|i| i.value}.should == NoteInterval.shift_and_zero_set(NoteInterval.dorian_set).map{|i| i.value}
  end

  it "lydian mode should equal shifted phrygian mode" do
    NoteInterval.lydian_set.map{|i| i.value}.should == NoteInterval.shift_and_zero_set(NoteInterval.phrygian_set).map{|i| i.value}
  end

  it "mixolydian mode should equal shifted lydian mode" do
    NoteInterval.mixolydian_set.map{|i| i.value}.should == NoteInterval.shift_and_zero_set(NoteInterval.lydian_set).map{|i| i.value}
  end

  it "aeolian mode should equal shifted mixolydian mode" do
    NoteInterval.aeolian_set.map{|i| i.value}.should == NoteInterval.shift_and_zero_set(NoteInterval.mixolydian_set).map{|i| i.value}
  end

  it "locrian mode should equal shifted aeolian mode" do
    NoteInterval.locrian_set.map{|i| i.value}.should == NoteInterval.shift_and_zero_set(NoteInterval.aeolian_set).map{|i| i.value}
  end

end
