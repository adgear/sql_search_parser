#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lib/sql_search/parser.rex".
#++

require 'racc/parser'
class SQLSearch::Parser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/[ \t]+/i))
        ;

      when (text = @ss.scan(/\d+\.\d+/i))
         action { [:APPROXNUM, text.to_f] }

      when (text = @ss.scan(/\d+/i))
         action { [:INTNUM, text.to_i] }

      when (text = @ss.scan(/'\d+-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}([+-]\d{2}:\d{2}|Z)'/i))
         action { [:TIME, DateTime.iso8601(text[1...-1])] }

      when (text = @ss.scan(/'[^']+'/i))
         action { [:STRING, text[1...-1]] }

      when (text = @ss.scan(/IS/i))
         action { [:IS, text] }

      when (text = @ss.scan(/NOT/i))
         action { [:NOT, text] }

      when (text = @ss.scan(/NULL/i))
         action { [:NULL, text.upcase] }

      when (text = @ss.scan(/IN/i))
         action { [:IN, text] }

      when (text = @ss.scan(/OR/i))
         action { [:OR, text] }

      when (text = @ss.scan(/AND/i))
         action { [:AND, text] }

      when (text = @ss.scan(/BETWEEN/i))
         action { [:BETWEEN, text] }

      when (text = @ss.scan(/LIKE/i))
         action { [:LIKE, text] }

      when (text = @ss.scan(/([<][>]|[=]|[<][=]|[<]|[>][=]|[>])/i))
         action { [:COMPARISON, text] }

      when (text = @ss.scan(/null/i))
         action { [:NULL, nil] }

      when (text = @ss.scan(/[A-z_]([A-z0-9_]*)/i))
         action {
    if ['true', 't'].include?(text)
      [:BOOL, true]
    elsif ['false', 'f'].include?(text)
      [:BOOL, false]
    elsif text == 'null'
      [:NULL, nil]
    else
      [:NAME, text]
    end
  }


      when (text = @ss.scan(/\(/i))
         action { [:LPAREN, text] }

      when (text = @ss.scan(/\)/i))
         action { [:RPAREN, text] }

      when (text = @ss.scan(/\./i))
         action { [:DOT, text] }

      when (text = @ss.scan(/\,/i))
         action { [:COMMA, text] }

      when (text = @ss.scan(/\+/i))
         action { [:ADD, text] }

      when (text = @ss.scan(/\-/i))
         action { [:SUBTRACT, text] }

      when (text = @ss.scan(/\//i))
         action { [:DIVIDE, text] }

      when (text = @ss.scan(/\*/i))
         action { [:MULTIPLY, text] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end # class
