require 'rubygems'
gem 'midiator'
require 'midiator'

require "mode"

class Piano

  include MIDIator::Notes
  include MIDIator::Drums

  @@midi = nil
  @@bpm = 120
  @@probability = 100
  @@variation = 0
  @@pentatonic = false
  @@randomness = 100
  @@key = 0
  @@octave = 0
  @@program = 1
  @@names = ['Acoustic Grand Piano', 'Bright Acoustic Piano', 'Electric Grand Piano', 'Honky-tonk Piano', 'Electric Piano 1', 'Electric Piano 2', 'Harpsichord', 'Clavinet', 'Celesta', 'Glockenspiel', 'Music Box', 'Vibraphone', 'Marimba', 'Xylophone', 'Tubular Bells', 'Dulcimer', 'Drawbar Organ', 'Percussive Organ', 'Rock Organ', 'Church Organ', 'Reed Organ', 'Accordion', 'Harmonica', 'Tango Accordion', 'Acoustic Guitar (nylon)', 'Acoustic Guitar (steel)', 'Electric Guitar (jazz)', 'Electric Guitar (clean)', 'Electric Guitar (muted)', 'Overdriven Guitar', 'Distortion Guitar', 'Guitar harmonics', 'Acoustic Bass', 'Electric Bass (finger)', 'Electric Bass (pick)', 'Fretless Bass', 'Slap Bass 1', 'Slap Bass 2', 'Synth Bass 1', 'Synth Bass 2', 'Violin', 'Viola', 'Cello', 'Contrabass', 'Tremolo Strings', 'Pizzicato Strings', 'Orchestral Harp', 'Timpani', 'String Ensemble 1', 'String Ensemble 2', 'Synth Strings 1', 'Synth Strings 2', 'Choir Aahs', 'Voice Oohs', 'Synth Choir', 'Orchestra Hit', 'Trumpet', 'Trombone', 'Tuba', 'Muted Trumpet', 'French Horn', 'Brass Section', 'Synth Brass 1', 'Synth Brass 2', 'Soprano Sax', 'Alto Sax', 'Tenor Sax', 'Baritone Sax', 'Oboe', 'English Horn', 'Bassoon', 'Clarinet', 'Piccolo', 'Flute', 'Recorder', 'Pan Flute', 'Blown Bottle', 'Shakuhachi', 'Whistle', 'Ocarina', 'Lead 1 (square)', 'Lead 2 (sawtooth)', 'Lead 3 (calliope)', 'Lead 4 (chiff)', 'Lead 5 (charang)', 'Lead 6 (voice)', 'Lead 7 (fifths)', 'Lead 8 (bass + lead)', 'Pad 1 (new age)', 'Pad 2 (warm)', 'Pad 3 (polysynth)', 'Pad 4 (choir)', 'Pad 5 (bowed)', 'Pad 6 (metallic)', 'Pad 7 (halo)', 'Pad 8 (sweep)', 'FX 1 (rain)', 'FX 2 (soundtrack)', 'FX 3 (crystal)', 'FX 4 (atmosphere)', 'FX 5 (brightness)', 'FX 6 (goblins)', 'FX 7 (echoes)', 'FX 8 (sci-fi)', 'Sitar', 'Banjo', 'Shamisen', 'Koto', 'Kalimba', 'Bag pipe', 'Fiddle', 'Shanai', 'Tinkle Bell', 'Agogo', 'Steel Drums', 'Woodblock', 'Taiko Drum', 'Melodic Tom', 'Synth Drum', 'Reverse Cymbal', 'Guitar Fret Noise', 'Breath Noise', 'Seashore', 'Bird Tweet', 'Telephone Ring', 'Helicopter', 'Applause', 'Gunshot']

  @@map = {
    '@'=>BassDrum2, '#'=>BassDrum1,
    '='=>SnareDrum2, '-'=>SnareDrum1,
    "'"=>ClosedHiHat, '"'=>OpenHiHat,
    '^'=>RideCymbal1, '`'=>CrashCymbal1, '*'=>CrashCymbal2, '<'=>Cowbell,
    '('=>MidTom1,  '_'=>MidTom2,  ')'=>LowTom2,
    }

  def self.menu

    %`
    > Pass in notes
    | cde edc d  c
    - .setup/
      - .key/
        - lydian) 4
        - ionian - major) 3
        - mixolydian) 2
        - dorian) 1
        - aeolian - minor) 0
        - phrygian) -1
        - locrian) -2
        - random/
      - .pentatonic/
        - off
        - on
      - .variation/
        - 0
        - 1
        - 2
        - 3
      - .bpm/
        - 60
        - 120
        - 240
        - 480
        - 960
      - .octave/
        - 2
        - 1
        - 0
        - -1
        - -2
      - .instrument/
        - most common/
          - Acoustic Grand Piano/
          - Electric Piano 1/
          - Glockenspiel/
          - Vibraphone/
          - Xylophone/
          - Drawbar Organ/
          - Church Organ/
          - Accordion/
          - Acoustic Guitar (nylon)/
          - Distortion Guitar/
          - Electric Bass (finger)/
          - Violin/
          - Tremolo Strings/
          - Pizzicato Strings/
          - Orchestral Harp/
          - Timpani/
          - String Ensemble 2/
          - Synth Strings 2/
          - Choir Aahs/
          - Synth Choir/
          - Orchestra Hit/
          - Trumpet/
          - Flute/
          - Pan Flute/
          - Lead 1 (square)/
          - Lead 2 (sawtooth)/
          - Pad 1 (new age)/
          - Pad 2 (warm)/
          - Pad 4 (choir)/
          - Pad 7 (halo)/
          - Pad 8 (sweep)/
          - FX 3 (crystal)/
          - FX 6 (goblins)/
          - Steel Drums/
          - Woodblock/
          - Taiko Drum/
        - all/
      - .probability/
        - 100%
        - 75%
        - 50%
      - .randomness/
        - 100%
        - 50%
        - 25%
      - .reset/
    - .generate/
    - .api/
      | Play some notes
      @ Piano.song "abc"
    - .docs/
      > Single notes
      - @piano/a/
      - @piano/b/
      - @piano/55/
      |
      > Multiple notes
      - @piano/cde edc d  c   c de e
      - @piano/some words for fun
      |
      > Multiple parts
      - .examples/
        - .chords/
        - .two parts/
        - .three parts/
        - .sharps/
        - .drums/
        - .unofficial xiki theme song/
      |
      > Keys
      keys/
        | For reference, here are the whole and half steps for the options under
        | the "key" menu.  By default the A scale is used.
        |
        | - O o o oo o oO: lydian
        | - O o oo o o oO: ionian (major)
        | - O o oo o oo O: mixolydian
        | - O oo o o oo O: dorian
        | - O oo o oo o O: aeolian (minor)
        | - Oo o o oo o O: phrygian
        | - Oo o oo o o O: locrian
    `
  end

  def self.names
    @@names
  end

  def self.chords
    "
    @piano/
      | A A A B A
      | C C D D C
      | E F F F E
    "
  end

  def self.two_parts
    "
    @piano/
      | CGcCGc C GaCGa  CGcCGc C GaCGa
      | cde edc d  c   c de e
    "
  end

  def self.three_parts
    "
    @piano/
      | ABCDEFGabcdefghijklmnopqrstuv
      |   B C D E F G a b c d e f g h
      |     B   C   D   E   F   G   a
    "
  end

  def self.sharps
    "
    @piano/
      |             #    # # # #
      | ce ecbca    Gb baGbG G G a
      |                    #
      |  C E C A C L B E B N B L H
    "
  end

  def self.drums
    "
    @piano/
      | ' ' ' ' ' ' * '
      | @  @=  @ _ )=
    "
  end

  def self.unofficial_xiki_theme_song
    "
    @piano/
      |                 xiki is so great
      | P Q P Q P Q P Q P Q P Q P Q P Q
      | < < < < < < < < < < < < < < < <
      | @ = @@= @ = @@= @ = @@= @ = @@=
    "
  end

  def self.menu_after menu_output, *args

    # Don't interfere if menu did something
    return menu_output if menu_output

    # If just number, intercept
    if args.length == 1 && args[0] =~ /^\d+$/
      self.note args[0].to_i
      return false
    end

    txt = ENV['txt']
    self.song txt, :move=>1

    nil
  end

  def self.song txt, options={}

    lines = txt.split("\n")#.reverse

    # Start at where cursor is
    View.column = Line.value[/.+(\/|\| ?)/].length if options[:move]

    longest = lines.inject(0){|acc, e| e.length > acc ? e.length : acc}

    longest.times do |i|

      sharp = false
      lines.each do |line|
        char = line[i] ? line[i].chr : nil
        self.note char, :no_sit=>1, :sharp=>sharp
        sharp = char == "#"
      end
      Move.forward if options[:move] && View.cursor != Line.right
      self.pause
    end
    nil
  end

  def self.clear channel=1
    @@midi.driver.control_change 123, channel, 123
  end

  def self.<< letter
    self.note letter
  end

  def self.letter_to_number letter #, adjustment=0
    adjustment =@@key

    letter.next! if @@pentatonic && (letter == "b" || letter == "e")

    number = letter[0].to_i
    number = case letter
    when "a".."z";  number - 96
    when "A".."G";  number - 71
    when "H".."N";  number - 85
    when "O".."U";  number - 99
    when "V".."Z";  number - 111
    else; raise "Don't know how to convert the note #{letter} to a number."
    end

    number = self.apply_variation number

    number = number * 12/7.0
    number -= 0.01
    adjustment -= 2
    adjustment = (adjustment / 7.0) - 0.01
    number += adjustment

    number = number.floor
    number += 68
    number
  end

  def self.apply_variation number, variation=nil

    return number if rand(100) > @@randomness   # Do nothing if randomness says to stop

    variation ||= @@variation
    number + rand(variation+1)
  end

  def self.apply_probability number
    return 0 if rand(100) > @@probability
    number
  end


  def self.note letter='a', options={}

    return if letter.nil? || letter == "#"

    channel, volume = 1, 126
    if letter.is_a? Fixnum
      number = letter
      # If super-low, make them audible
      number += 69 if number <= 20
    elsif letter =~ /^[0-9]$/
      number = letter[0] + 21
    elsif letter =~ /^[a-zA-Z]$/
      number = self.letter_to_number letter # , @@key
      number = self.apply_probability number
    elsif letter.length == 1 && letter.count("@#='\"`^*<(_)-") == 1
      channel = 10
      number = @@map[letter]
      volume = 65 unless letter.count("@#=-") == 1
    elsif letter == " "
      number = 0
    elsif letter.is_a?(String) && letter.length > 1
      letter.split('').each{|o| self.note o}
      return
    else
      raise "- Note #{letter.inspect} not recognized!"
    end

    return if number == 0

    number += 1 if options[:sharp]
    number += (@@octave * 12)
      #       number -= 12   # Make an octive lower

    @@midi.driver.note_on(number, channel, volume) unless number == 0

    return if options[:no_sit]

    self.pause
    nil
  end

  def self.pause

    pause = @@bpm * 4
    pause = pause / 60.0
    pause = 1 / pause
    $el.sit_for pause
    Piano.clear
    Piano.clear 10
  end

  def self.keydef letter, note, channel=1, velocity=126
    $el.define_key(:piano_mode_map, letter) do
      @@midi.driver.note_on(note, channel, velocity)
    end
  end

  def self.midi
    @@midi
  end

  def self.keys
    $el.elvar.piano_mode_map = $el.make_sparse_keymap unless $el.boundp :piano_mode_map

    keydef " ", BassDrum2, 10
    keydef "-", SnareDrum2, 10
    keydef "1", SnareDrum1, 10

    keydef "6", ClosedHiHat, 10, 60
    keydef "1", OpenHiHat, 10, 60
    keydef $el.kbd("C-i"), RideCymbal1, 10, 60

    # Note: keys are optimized for dvorak
    keydef ";", C3; keydef "o", Cs3
    keydef "q", D3; keydef "e", Ds3
    keydef "j", E3

    keydef "k", F3; keydef "i", Fs3
    keydef "x", G3; keydef "d", Gs3
    keydef "b", A3; keydef "h", As3
    keydef "m", B3
    keydef "w", C4; keydef "n", Cs4
    keydef "v", D4; keydef "s", Ds4
    keydef "z", E4

    keydef "'", B3; keydef "3", Cs4
    keydef ",", C4; keydef "3", Cs4
    keydef ".", D4; keydef "4", Ds4
    keydef "p", E4
    keydef "y", F4; keydef "6", Fs4
    keydef "f", G4; keydef "7", Gs4
    keydef "g", A4; keydef "8", As4
    keydef "c", B4
    keydef "r", C5; keydef "0", Cs5
    keydef "l", D5; keydef "[", Ds5
    keydef "/", E5
    keydef "=", F5
    keydef '\\\\', G5

    "aut259]".split(//).each do |letter|
      $el.define_key(:piano_mode_map, letter) do
        View.message("key '#{letter}' inactive")
      end

    end

    keydef "", :nothing   # nothing


    $el.define_key(:piano_mode_map, $el.kbd("<right>")) do
      @@program += 1
      View.message "program: #{@@program+1} - #{@@names[@@program]}"
      @@midi.program_change 1, @@program
    end

    $el.define_key(:piano_mode_map, $el.kbd("<left>")) do
      @@program -= 1
      View.message "program: #{@@program+1} - #{@@names[@@program]}"
      @@midi.program_change 1, @@program
    end

    $el.define_key(:piano_mode_map, $el.kbd("<backspace>")) do
      @@midi.control_change 123, 1, 123
    end
  end

  def self.init
    self.keys
    # Make piano mode happen for .piano files
    Mode.define(:piano, ".piano") do
      Notes.apply_styles
    end
    self.connect if @@midi.nil?
  end

  def self.instrument type, name=nil, options={}
    return @@names.map{|o| "- #{o}/"}.join("\n") if name.nil?
    index = @@names.index name
    @@midi.program_change 1, index
    return if options[:quiet]
    Piano.note "abc"
  end

  def self.reset
    self.connect

    @@bpm = 120
    @@probability = 100

    @@variation = 0
    @@pentatonic = false
    @@randomness = 100
    @@key = 0
    @@octave = 0
    @@program = 1

    ".flash - success!"
  end

  def self.connect
    @@midi = MIDIator::Interface.new
    @@midi.use :dls_synth
    @@midi.control_change 32, 10, 1 # TR-808 is Program 26 in LSB bank 1
    @@midi.program_change 10, 26
  end

  def self.bpm txt;  @@bpm = txt.to_i;  ".flash - updated!";  end
  def self.probability txt;  @@probability = txt.sub('%', '').to_i;  ".flash - updated!";  end
  def self.variation txt;  @@variation = txt.to_i;  ".flash - updated!";  end
  def self.pentatonic txt;  @@pentatonic = txt == "on";  ".flash - updated!";  end
  def self.randomness txt;  @@randomness = txt.sub('%', '').to_i;  ".flash - updated!";  end
  def self.octave txt;  @@octave = txt.to_i;  ".flash - updated!";  end

  def self.key txt=nil
    return @@key if txt.nil?

    if txt == "random"
      random = (-2..4).to_a[rand 7]
      @@key = random
      return ".flash - updated to #{random}!"
    end

    @@key = txt.to_i
    ".flash - updated!"
  end

  def self.generate range=nil, notes=nil

    if range.nil?
      return "- a..g/"
    end

    # If just range, generate

    if notes.nil?

      range ||= "a..g"

      range =~ /(.+)\.\.(.+)/
      range = $1..$2

      range = range.to_a

      txt = ""
      8.times do
        txt << range[rand range.length]
      end
      return "| #{txt}"
    end

    self.song ENV['txt']
    nil
  end

end

Piano.init   # Define mode
Menu.drums :menu=>'piano'
