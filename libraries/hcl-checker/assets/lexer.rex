class HCL::Checker::Lexer
option
  independent

macro
  NEWLINE               \n|\r
  BLANK                 \s+
  COMMENT               \#.*|\/\/.*$
  MCOMMENTIN            \/\*
  BOOL                  true|false
  NUMBER                -?\d+
  FLOAT                 \-?\d+\.\d+
  COMMA                 \,
  IDENTIFIER            [a-zA-Z_][a-zA-Z0-9_\-\.]*
  EQUAL                 \=
  QUOTE                 \"
  MINUS                 \-
  LEFTBRACE             \{
  RIGHTBRACE            \}
  LEFTBRACKET           \[
  RIGHTBRACKET          \]
  LEFTPARENTHESES       \(
  RIGHTPARENTHESES      \)
  HEREDOCUMENT          \<<\-?

rule
# [:state]      pattern                   [actions]
#-------------------------------------------------------------------------------
                {BLANK}                   # ignore pattern
                {COMMENT}                 # ignore pattern
                {NEWLINE}                 # ignore pattern
#-------------------------------------------------------------------------------
                {MCOMMENTIN}              { consume_comment(text) }
                {BOOL}                    { [:BOOL,         to_boolean(text)]}
                {FLOAT}                   { [:FLOAT,        text.to_f] }
                {NUMBER}                  { [:NUMBER,       text.to_i] }
                {QUOTE}                   { [:STRING,       consume_string(text)] }
                {HEREDOCUMENT}            { [:STRING,       consume_heredoc] }
#-------------------------------------------------------------------------------
                {LEFTBRACE}               { [:LEFTBRACE,        text]}
                {RIGHTBRACE}              { [:RIGHTBRACE,       text]}
                {LEFTBRACKET}             { [:LEFTBRACKET,      text]}
                {RIGHTBRACKET}            { [:RIGHTBRACKET,     text]}
                {LEFTPARENTHESES}         { [:LEFTPARENTHESES,  text]}
                {RIGHTPARENTHESES}        { [:RIGHTPARENTHESES, text]}
#-------------------------------------------------------------------------------
                {COMMA}                   { [:COMMA,        text]}
                {IDENTIFIER}              { [:IDENTIFIER,   text]}
                {EQUAL}                   { [:EQUAL,        text]}
                {MINUS}                   { [:MINUS,        text]}

inner
  def lex(input)
    scan_setup(input)
    tokens = []
    while token = next_token
      tokens << token
    end

    tokens
  end


  def to_boolean(input)
    case input
    when /true/
      true
    when /false/
      false
    else
      raise "Invalid value for `to_boolean`, expected true/false got #{input}"
    end
  end


  def consume_comment(input)
    nested = 1

    until nested.zero?
      case(text = @ss.scan_until(%r{/\*|\*/|\z}) )
      when %r{/\*\z}
        nested =+ 1
      when %r{\*/\z}
        nested -= 1
      else
        break
      end
    end
  end


  def consume_string(input)
    result = ''
    nested = 0

    loop do
      case(text = @ss.scan_until(%r{\"|\$\{|\}|\\}))
      when %r{\$\{\z}
        nested += 1
      when %r{\}\z}
        nested -= 1 if nested.positive?
      when %r{\\\z}
        result += text.chop + @ss.getch
        next
      end

      result += text.to_s

      break if nested.zero? && text =~ %r{\"\z}
    end

    result.chop
  end

  def consume_heredoc
      token = Regexp.new @ss.scan_until(%r{\n})
      document = @ss.scan_until(token)

      document.chop
  end
end
