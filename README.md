# rb-music-theory

# This fork is deprecated
Please check out [rb-music](https://github.com/mwise/rb-music) for a more robust and better-tested Ruby music library.

## Prerequisites
* Ruby 1.9.2 or greater

## Install

In your Gemfile:

```
gem 'rb-music-theory', git: 'https://github.com/mwise/rb-music-theory', branch: 'master'
```

In your Ruby code:

```
require 'rb-music-theory'
```

## Overview

Basic twelve-tone music theory including notes, note intervals, scales, chords

### Note

A Note has an Integer value indicating its place on the chromatic scale. Compatible with MIDI note numbers - see http://www.phys.unsw.edu.au/jw/notes.html for more info about MIDI.

### NoteInterval

A NoteInterval is used to transform a Note into a new Note.
(Note + Fixnum => Note)
(Note + NoteInterval => Note)

```
  irb(main):009:0> Note.new("C")
  => #<Note:0x267a0c8 @value=60>
  irb(main):010:0> Note.new("C").name
  => "C"
  irb(main):011:0> Note.new("C") + NoteInterval.new(12)
  => #<Note:0x2677d64 @value=72>
  irb(main):012:0> Note.new("C") + NoteInterval.octave
  => #<Note:0x2678f0c @value=72>
  irb(main):013:0> (Note.new("C") + NoteInterval.octave).name
  => "C"
```
Notice:

* NoteInterval.octave is the same as NoteInterval.new(12)
* plus_interval may also be used instead of + to chain the method calls

NoteIntervals can be added together.
(NoteInterval + Fixnum => NoteInterval)
(NoteInterval + NoteInterval => NoteInterval)
```
  irb(main):005:0> NoteInterval.new(5).plus_interval(NoteInterval.new(7))
  => #<NoteInterval:0x2677c10 @value=12>
  irb(main):006:0> NoteInterval.new(5) + NoteInterval.new(7)
  => #<NoteInterval:0x26781d8 @value=12>
  irb(main):007:0> NoteInterval.new(5) + 7
  => #<NoteInterval:0x2679858 @value=12>
```

### Scales and Chords

Both of these classes share a superclass RootNoteWithIntervals which gives
a root Note, and an array of NoteIntervals.

As shown above, the NoteIntervals applied to the root
Note will yield the actual Notes in the Scale or Chord.

Often you'll just ask a Scale or Chord for its note_names.  But you still have access to the intervals, notes and
note_values too.

```ruby
class RootNoteWithIntervals

  def notes
    @intervals.map{|i| @root_note.plus_interval(i)}
  end

  def note_names
    self.notes.map{|n| n.name}
  end

  def note_values
    self.notes.map{|n| n.value}
  end

end
```

```
irb(main):055:0> Note.new("C").major_scale.note_names
=> ["C", "D", "E", "F", "G", "A", "B"]
irb(main):056:0> Note.new("F#").major_scale.note_names
=> ["F#", "G#", "A#", "B", "C#", "D#", "F"]
```

#### Degrees

Asking a Scale for a degree gives you the note at that position (1-based).  Degrees higher than 7 wrap
around the scale to the next octave.
```
  irb(main):073:0> Note.new("C").major_scale.degree(1)
  => #<Note:0x2674e98 @value=60>
  irb(main):074:0> Note.new("C").major_scale.degree(1).name
  => "C"
  irb(main):075:0> Note.new("C").major_scale.degree(8)
  => #<Note:0x2674e84 @value=72>
  irb(main):076:0> Note.new("C").major_scale.degree(8).name
  => "C"
  irb(main):077:0> Note.new("C").major_scale.degree(9)
  => #<Note:0x2674de4 @value=74>
  irb(main):078:0> Note.new("C").major_scale.degree(9).name
  => "D"
```

#### Chords

```
  irb(main):001:0> Note.new("C").major_chord
  => #<Chord:0x267a834 @intervals=[#<NoteInterval:0x267a71c @value=0>, #<NoteInterval:0x267a708 @value=4>, #<NoteInterval:0x267a6f4 @value=7>], @root_note=#<Note:0x267a870 @value=60>>
  irb(main):002:0> Note.new("C").major_chord.note_names
  => ["C", "E", "G"]
  irb(main):003:0> Note.new("C").maj7_chord.note_names
  => ["C", "E", "G", "B"]
```

#### Chord Inversions

```
  irb(main):001:0> Note.new("C").major_chord
  => #<Chord:0x287b408 @intervals=[#<NoteInterval:0x287b2f0 @value=0>, #<NoteInterval:0x287b2dc @value=4>, #<NoteInterval:0x287b2c8 @value=7>], @root_note=#<Note:0x287b444 @value=60>>
  irb(main):002:0> Note.new("C").major_chord.note_names
  => ["C", "E", "G"]
  irb(main):003:0> Note.new("C").major_chord.invert.note_names
  => ["E", "G", "C"]
  irb(main):004:0> Note.new("C").major_chord.invert.invert.note_names
  => ["G", "C", "E"]
  irb(main):005:0> Note.new("C").major_chord.invert.invert.invert.note_names
  => ["C", "E", "G"]
  irb(main):006:0> Note.new("C").major_chord.invert.invert.invert
  => #<Chord:0x28793c4 @intervals=[#<NoteInterval:0x287934c @value=0>, #<NoteInterval:0x2879338 @value=4>, #<NoteInterval:0x2879324 @value=7>], @root_note=#<Note:0x2879374 @value=72>>
```

#### Valid Chords for Scale Degrees

```
irb(main):001:0> Note.new("C").major_scale.valid_chord_names_for_degree(1)
=> ["maj7_chord", "six_nine_chord", "add4_chord", "add2_chord", "sixth_chord", "maj11_chord", "maj_add2_chord", "maj_add9_chord", "major_chord", "sus4_chord", "maj_add4_chord", "fifth_chord", "sus2_chord", "maj9_chord", "add9_chord"]
```
(some of these chord_names are synonyms, so there are duplicates)

#### Harmonized Chord-Scales

Given a Scale, you may describe a Chord to be "walked" up the scale such that
only Notes in that Scale are used.

harmonized_chord(start_degree,chord_name) => Chord
```
  irb(main):005:0> Note.new("C").major_scale.harmonized_chord(1,:maj7_chord).note_names
  => ["C", "E", "G", "B"]
  irb(main):006:0> Note.new("C").major_scale.harmonized_chord(2,:maj7_chord).note_names
  => ["D", "F", "A", "C"]
  irb(main):007:0> Note.new("C").major_scale.harmonized_chord(3,:maj7_chord).note_names
  => ["E", "G", "B", "D"]
  irb(main):008:0> Note.new("C").major_scale.harmonized_chord(4,:maj7_chord).note_names
  => ["F", "A", "C", "E"]
  irb(main):009:0> Note.new("C").major_scale.harmonized_chord(5,:maj7_chord).note_names
  => ["G", "B", "D", "F"]
```

Or do it all at once:

all_harmonized_chords(chord_name) => array of Chords
```
  irb(main):003:0> Note.new("C").major_scale.all_harmonized_chords(:maj7_chord).map{|c| c.note_names}
  => [["C", "E", "G", "B"], ["D", "F", "A", "C"], ["E", "G", "B", "D"], ["F", "A", "C", "E"], ["G", "B", "D", "F"], ["A", "C", "E", "G"], ["B", "D", "F", "A"]]
```

Or, to get the MIDI note numbers instead of the note names
```
  irb(main):004:0> Note.new("C").major_scale.all_harmonized_chords(:maj7_chord).map{|c| c.note_values}
  => [[60, 64, 67, 71], [62, 65, 69, 72], [64, 67, 71, 74], [65, 69, 72, 76], [67, 71, 74, 77], [69, 72, 76, 79], [71, 74, 77, 81]]
```

Or, get your Phryg on
```
  irb(main):017:0> Note.new("C").phrygian_scale.all_harmonized_chords(:min7_chord).map{|c| c.note_names}
  => [["C", "D#", "G", "A#"], ["C#", "F", "G#", "C"], ["D#", "G", "A#", "C#"], ["F", "G#", "C", "D#"], ["G", "A#", "C#", "F"], ["G#", "C", "D#", "G"], ["A#", "C#", "F", "G#"]]
  irb(main):018:0>
```

#### Examples

These projects use rb-music-theory

Olympiano - http://github.com/chrisbratlien/olympiano/tree/master

Rollo - http://github.com/chrisbratlien/rollo/tree/master
