module Ink
  def self.R(*args, &blk)
    return Ink::R::RelationString.new(Ink::R::build("", *args, &blk))
  end

  module R
    class RelationString
      def initialize(str="")
        @sql = str
      end

      def method_missing(prefix, *args, &blk)
        @sql += " " + Ink::R::build(prefix, *args, &blk)
        return self
      end

      def to_s
        return @sql
      end
      alias_method :to_sql, :to_s
    end

    def self.method_missing(prefix, *args, &blk)
      return RelationString.new(self.build(prefix, *args, &blk))
    end

    def self.build(prefix, *args, &blk)
      prefix = prefix.to_s.upcase
      str = prefix
      unless args.empty?
        str += " " + args.map(&:to_s).join(', ')
      end
      if blk
        str += " " + blk.call + " "
      end
      return str
    end
  end
end
