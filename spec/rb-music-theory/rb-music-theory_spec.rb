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

describe RootNoteWithIntervals do
  let(:subject) { Note.new("C").major_scale }

  it "should contain an integer note value" do
    subject.contains_note_value?(Note.new("C").value).should == true
  end

  it "should contain note values of another" do
    subject.contains_note_values_of?(Note.new("C").major_chord).should == true
  end
  it "should contain note names of another" do
    subject.contains_note_names_of?(Note.new("C").major_chord).should == true
  end

  it "should describe the note names in common between scales" do
    subject.note_names_in_common(Note.new("A").minor_scale).should == ['C','D','E','F','G','A','B']
  end

  it "describes the interval names" do
    subject.interval_names.should == %w{ 1 2 3 4 5 6 7 }
  end

  it "describes the interval values" do
    subject.interval_values.should == [0, 2, 4, 5, 7, 9, 11]
  end

  it "describes the note interval / note pairs" do
    subject = RootNoteWithIntervals.new(Note.new("C"), [2, 4])
    subject.nin_pairs[0][0].should == 2
    subject.nin_pairs[0][1].should be_a(Note)

    subject.nin_pairs[1][0].should == 4
    subject.nin_pairs[1][1].should be_a(Note)
  end

  describe "#add" do

    it "adds a note" do
      note = Note.new("F#")
      subject.add(note).interval_values.should include(6)
    end

    it "adds an interval" do
      interval = NoteInterval.new(8)
      subject.add(interval).interval_values.should include(8)
    end

    it "adds another RootNoteWithIntervals" do
      other_subject = RootNoteWithIntervals.new(Note.new("C#"), [0, 2])

      subject.add(other_subject).interval_values.should == [0, 1, 2, 3, 4, 5, 7, 9, 11]
    end

    it "adds an array of intervals" do
      other_subject = [NoteInterval.new(1), NoteInterval.new(3)]
      subject.add(other_subject).interval_values.should == [0, 1, 2, 3, 4, 5, 7, 9, 11]
    end

  end

  describe "#remove" do

    it "removes a note" do
      note = Note.new("E")
      subject.remove(note).interval_values.should_not include(4)
    end

    it "removes an interval" do
      interval = NoteInterval.new(4)
      subject.remove(interval).interval_values.should_not include(4)
    end

    it "removes a RootNoteWithIntervals" do
      other_subject = RootNoteWithIntervals.new(Note.new("D"), [0, 2])

      subject.remove(other_subject).interval_values.should == [0, 5, 7, 9, 11]
    end

    it "removes an array of intervals" do
      other_subject = [NoteInterval.new(5), NoteInterval.new(7)]
      subject.remove(other_subject).interval_values.should == [0, 2, 4, 9, 11]
    end

  end


end

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
