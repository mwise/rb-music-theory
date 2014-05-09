require_relative '../spec_helper'

describe Chord do

  it "should produce a major chord" do
    Note.new("C").major_chord.note_names.should == ["C", "E", "G"]
  end

  it "chord inversion should have the same note names" do
    c1 = Note.new("C").major_chord
    c2 = c1.invert
    c3 = c2.invert
    c2.note_names.sort.should == c1.note_names.sort
    c3.note_names.sort.should == c2.note_names.sort
  end

  it "should remove a note" do
    Note.new("C").major_chord.remove_note(Note.new("C")).note_names.should == ["E","G"]
  end

  it "should add a note" do
    Note.new("C").major_chord.add_note(Note.new("B")).note_names.should == ["C","E","G","B"]
  end

  it "should add 2 chords" do
    (Note.new("C").maj7_chord + Note.new("D").minor_chord).notes.should == Note.new("C").major_scale.notes
  end

end
