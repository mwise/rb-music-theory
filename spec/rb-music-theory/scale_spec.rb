require_relative '../spec_helper'

describe Scale do

  before(:all) do
    @c_maj_scale = Note.new("C").major_scale
    @c_maj_scale_note_names = ["C", "D", "E", "F", "G", "A", "B"]
  end

  it "should produce a chromatic scale" do
    Note.new("C").chromatic_scale.note_names.should == ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
  end

  it "should produce a major scale with correct note names" do
    @c_maj_scale.note_names.should == @c_maj_scale_note_names
  end

  it "should have the correct major scale degrees" do
    (1..7).to_a.map{|d| @c_maj_scale.degree(d).name }.should == @c_maj_scale_note_names
  end

  it "should produce a correct A natural minor scale" do
    Note.new("A").natural_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F", "G"]
  end

  it "should produce a correct A harmonic minor scale" do
    Note.new("A").harmonic_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F", "G#"]
  end

  it "should produce a correct A melodic minor scale" do
    Note.new("A").melodic_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F#", "G#"]
  end

  it "should report the correct interval sizes for degrees" do
    @c_maj_scale.interval_for_degree(1).value.should == 0
    @c_maj_scale.interval_for_degree(2).value.should == 2
    @c_maj_scale.interval_for_degree(3).value.should == 4
    @c_maj_scale.interval_for_degree(4).value.should == 5
    @c_maj_scale.interval_for_degree(5).value.should == 7
    @c_maj_scale.interval_for_degree(6).value.should == 9
    @c_maj_scale.interval_for_degree(7).value.should == 11
    @c_maj_scale.interval_for_degree(8).value.should == 12
    @c_maj_scale.interval_for_degree(9).value.should == 14
    @c_maj_scale.interval_for_degree(10).value.should == 16
    @c_maj_scale.interval_for_degree(11).value.should == 17
    @c_maj_scale.interval_for_degree(12).value.should == 19
    @c_maj_scale.interval_for_degree(13).value.should == 21
    @c_maj_scale.interval_for_degree(14).value.should == 23
    @c_maj_scale.interval_for_degree(15).value.should == 24
  end

  it "should subtract a chord" do
    (Note.new("C").major_scale - Note.new("C").major_chord).note_names.should == ["D","F","A","B"]
  end

  it "should produce a harmonized scale when given a chord" do
    Note.new("C").major_scale.all_harmonized_chords(:major_chord).map{|c| c.note_names}.should ==
    [["C","E","G"],["D","F","A"],["E","G","B"],["F","A","C"],["G","B","D"],["A","C","E"],["B","D","F"]]
  end

  it "should build the same chord when harmonizing a scale as when building that chord off the root note" do
    Note.scale_methods.each{ |sn|
      Note.new("C").send(sn).valid_chord_names_for_degree(1).each {|cn|
         Note.new("C").send(sn).harmonized_chord(1,cn).note_names.should == Note.new("C").send(cn).note_names
       }
     }
  end

end
