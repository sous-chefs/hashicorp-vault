class HCL::Checker::Parser
token BOOL
      FLOAT
      NUMBER
      COMMA
      COMMAEND
      IDENTIFIER
      EQUAL
      STRING
      MINUS
      LEFTBRACE
      RIGHTBRACE
      LEFTBRACKET
      RIGHTBRACKET
      LEFTPARENTHESES
      RIGHTPARENTHESES
      PERIOD
      EPLUS
      EMINUS

rule
  target: top { @result = flatten_objectlist(val[0])}

  top:
      { result = val[0] }
  |  objectlist
  ;

  objectlist:
     objectitem COMMA
       { result = [val[0]] }
  |  objectitem
       { result = [val[0]] }
  |  objectlist objectitem COMMA
       { result = val[0] << val[1]  }
  |  objectlist objectitem
       { result = val[0] << val[1]  }
  ;

  object:
     LEFTBRACE objectlist RIGHTBRACE
       { result = flatten_objectlist(val[1]) }
  |  LEFTBRACE RIGHTBRACE
       { return }
  ;

  objectkey:
     IDENTIFIER
       { result = val[0] }
  |  STRING
       { result = val[0] }
  ;

  objectitem:
     objectkey EQUAL number
       { result = val[0], val[2] }
  |  objectkey EQUAL BOOL
       { result = val[0], val[2] }
  |  objectkey EQUAL STRING
       { result = val[0], val[2] }
  |  objectkey EQUAL object
       { result = val[0], val[2] }
  |  objectkey EQUAL list
       { result = val[0], val[2] }
  |  objectkey EQUAL IDENTIFIER LEFTPARENTHESES IDENTIFIER RIGHTPARENTHESES
       { result = val[0], "#{val[2]}(#{val[4]})" }
  |  objectkey EQUAL IDENTIFIER
       { result = val[0], val[2] }
  |  block
       { result = val[0] }
  ;

  block:
     block_id object
       { result = val[0], val[1] }
  |  block_id block
       { result = val[0], {val[1][0] => val[1][1]} }
  ;

  block_id:
     IDENTIFIER
       { result = val[0] }
  |  STRING
       { result = val[0] }
  ;

  list:
     LEFTBRACKET listitems RIGHTBRACKET
       { result = val[1] }
  |  LEFTBRACKET RIGHTBRACKET
       { return }
  ;

  listitems:
     listitem
       { result = [val[0]] }
  |  listitems COMMA listitem
       { result = val[0] << val[2] }
  |  listitems COMMA
       { result = val[0] }
  ;

  listitem:
     number
       { result = val[0] }
  |  STRING
       { result = val[0] }
  | list
       { result = val[0] }
  | object
       { result = val[0] }
  ;

  number:
     NUMBER
       { result = val[0] }
  |  FLOAT
       { result = val[0] }
  ;


end

---- header
require_relative 'lexer'

---- inner
  #//
  #//       HCL is unclear on what one should do when duplicate
  #//       keys are encountered.
  #//
  #//       from decoder.go: if we're at the root or we're directly within
  #//                        a list, decode to hashes, otherwise lists
  #//
  #//       from object.go:  there is a flattened list structure
  #//
  #//       if @duplicate_mode is set:
  #//         - :array then duplicates will be appended to an array
  #//         - :merge then duplicates will be deep merged into a hash
  #//
  def flatten_objectlist(list)
    (list || {}).each_with_object({}) do |a, h|
      if h.keys.include?(a.first)
        case @duplicate_mode
        when :array
          if h[a.first].is_a?(Array)
            h[a.first].push(a.last)
          else
            h[a.first] = [ h[a.first], a.last ]
          end
        when :merge
          deep_merge(h[a.first] || {}, a.last)
        else raise ArgumentError
        end
      else
        h[a.first] = a.last
      end
    end
  end


  def on_error(error_token_id, error_value, value_stack)
    error_message = value_stack.to_s.split(',').last.gsub(']', '')
    header = "Parse error at #{error_message} #{error_value} (invalid token: #{error_value})"
    raise Racc::ParseError, header
  end


  def parse(input, duplicate_mode = :array)
    @duplicate_mode = duplicate_mode
    @lexer = HCL::Checker::Lexer.new.lex(input)
    do_parse

    @result
  end


  def next_token
    @lexer.shift
  end

  def deep_merge(hash1, hash2)
    hash2.keys.each do |key|
      value1 = hash1[key]
      value2 = hash2[key]

      if value1.is_a?(Hash) && value2.is_a?(Hash)
        hash1[key] = deep_merge(value1, value2)
      else
        hash1[key] = value2
      end
    end

    hash1
  end
