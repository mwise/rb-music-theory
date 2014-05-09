require_relative '../spec_helper'

describe Note do

  it "should produce octaves with plus_interval correctly" do
    Note.twelve_tones.each do |tone_name|
      orig_note = Note.new(tone_name)
      high_note = orig_note.plus_interval(NoteInterval.octave)
      high_note.name.should == orig_note.name
      high_note.value.should == orig_note.value + 12
    end
  end

  it "plus_interval should fail when passed another Note" do
    proc { Note.new("C").plus_interval(Note.new("C")) }.should raise_error(TypeError)
  end

end
