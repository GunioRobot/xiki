require 'keys'

# Provides different ways of moving cursor.
class Move
  extend ElMixin

  # Go to last line having indent
  def self.to_indent
    direction_down = true   # Assume down
    prefix = Keys.prefix
    line = Line.value

    if prefix.is_a? Fixnum   # If U, reverse
      indent = prefix   # If numeric, make that be the indent
    else
      direction_down = ! direction_down if line =~ /^ *(end|\]|\}|\))$/   # If end of block, reverse direction

      if prefix == :u   # If U, reverse
        direction_down = false
      else
      end
    end

    column = View.column
    indent ||= Line.indent(line).size

    # If negative, reverse direction and amke positive
    if indent < 0
      direction_down = false
      indent = 0 - indent
    end

    orig = Location.new
    # Search for matching in right direction
    if direction_down == false
      Line.to_left
      success = Search.backward "^ \\{#{indent}\\}[^ \t\n]"
    else
      Line.next
      success = Search.forward "^ \\{#{indent}\\}[^ \t\n]"
    end

    Move.to_column prefix.is_a?(Fixnum) ? indent : column


    unless success
      View.beep
      orig.go
    end
  end

  def self.to_next_paragraph
    pref = Keys.prefix || 1
    if Keys.prefix_u?  # If C-u, just go to end
      re_search_forward "^[ \t]*$", nil, 1
      beginning_of_line
      return
    end
    pref.times do
      re_search_forward "\n[ \t]*\\(\n+[ \t]*\\)+", nil, 1
    end
    beginning_of_line
  end

  def self.to_previous_paragraph
    pref = elvar.current_prefix_arg || 1
    pref.times do
      skip_chars_backward "\n "
      re_search_backward "\n[ \t]*\\(\n+[ \t]*\\)+", nil, 1
    end
    skip_chars_forward "\n "
    beginning_of_line
  end

  def self.to_window n, options={}

    views = View.list   # Get views in this window

    if n >= views.size   # If they wanted to go further than exists
      select_window(views[views.size - 1])
    else
      select_window(views[n-1])
    end

    Effects.blink(:what=>:line) if options[:blink]
  end

  def self.to_last_window options={}

    View.to_nth(View.list.size - 1)

    Effects.blink(:what=>:line) if options[:blink]
  end

  def self.to_line n=nil
    # Use arg or numeric prefix or get input
    n = n || elvar.current_prefix_arg || Keys.input(:prompt=>"Go to line number: ")
    goto_line n.to_i
  end

  # Move to the specified column.
  def self.to_column n=nil
    n = n || elvar.current_prefix_arg || Keys.input(:prompt => "Enter number of column to go to: ").to_i
    move_to_column n# - 1
  end

  # Go to opposite bracket
  def self.to_other_bracket
    prefix = Keys.prefix
    # If prefix or after closing bracket, go backward
    last_char = point == 1 ? "" : buffer_substring(point-1, point)

    # If numeric prefix
    if prefix.class == Fixnum
      if prefix > 0
        prefix.times { forward_sexp }
      else
        (0-prefix).times { backward_sexp }
      end
    elsif prefix == :u or last_char =~ /[)}\]'">]/
      backward_sexp
    # Otherwise, go forward
    else
      forward_sexp
    end
  end

  def self.backward count=nil
    count ||= Keys.prefix :clear => true
    count ||= 1
    case count
    when :u; backward_word 1
    when :uu; backward_word 2
    when :uuu; backward_word 3
    else
      backward_char(count)
    end
  end

  def self.forward count=nil

    count ||= Keys.prefix :clear => true
    count ||= 1
    case count
    when :u
      forward_word 1
    when :uu
      forward_word 2
    when :uuu
      forward_word 3
    else
      forward_char(count)
    end
  end

  def self.top
    beginning_of_buffer
  end

  def self.bottom
    end_of_buffer
  end

  def self.to_quote
    prefix = Keys.prefix :clear=>true
    if prefix.nil?
      times = 1
      Keys.clear_prefix
    elsif prefix.is_a? Fixnum
      times = prefix
      View.to_relative
    end

    (times||1).times do
      Line.next if Line.matches(/^ *\|/)
      re_search_forward "^ +|"
      backward_char
    end

    # If on a quote, move off
  end

  # Move to file in tree (not dir) ?
  def self.to_junior
    Keys.prefix_times.times do
      # Move to line without / at end
      Line.next if Line.matches(/^ +[+-]? ?[a-zA-Z_-].+[^\/\n]$/)
      re_search_forward "^ +[+-]? ?[a-zA-Z_-].+[^\/\n]$"
      Line.to_words
    end
  end

  def self.to_axis
    n = Keys.prefix_n   # Check for numeric prefix
    Line.next(n) if n.is_a? Fixnum   # If there, move down
    Line.to_left
  end

  def self.to_end n=nil
    n ||= Keys.prefix_n   # Check for numeric prefix
    Line.next(n) if n.is_a? Fixnum   # If there, move down
    Line.to_right
  end

end
