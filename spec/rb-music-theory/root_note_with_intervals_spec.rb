require_relative '../spec_helper'

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
