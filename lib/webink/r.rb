module Ink
  def self.R!(*args, &blk)
    return Ink::R::RelationString.new(Ink::R::build("_!", *args, &blk))
  end

  module R
    class RelationString
      def initialize(str="")
        @sql = [str]
      end

      def method_missing(prefix, *args, &blk)
        @sql << Ink::R::build(prefix, *args, &blk)
        return self
      end

      def to_s
        return @sql.flatten.join
      end
      alias_method :to_sql, :to_s
      alias_method :to_str, :to_s
    end

    def self.method_missing(prefix, *args, &blk)
      return RelationString.new(self.build(prefix, *args, &blk))
    end

    def self.build(prefix, *args, &blk)
      prefix = prefix.to_s.upcase
      prefix, control_chars = self.split_control_chars(prefix)

      space_prefix = control_chars.include?('_') ? '' : ' '
      wrap_chars = control_chars.include?('!') ?
        [space_prefix + '(', ')'] :
        [space_prefix, '']
      prefix_prefix = control_chars.include?('_') &&
        control_chars.include?('!') ? '' : ' '

      str = prefix.empty? ? [] : [prefix_prefix + prefix]
      str << (!args.empty? || blk ? wrap_chars[0] : '')
      unless args.empty?
        str << args.map(&:to_s).join(', ')
      end
      if blk
        str << blk.call(RelationString.new).to_s
      end
      str << (!args.empty? || blk ? wrap_chars[1] : '')
      return str
    end

    private
    def self.split_control_chars(string)
      control_char_match = string.match(/([_!]+)$/)
      if control_char_match
        m = control_char_match[1]
        return [string[0, string.length - m.length], m.split('')]
      else
        return [string, []]
      end
    end
  end
end
