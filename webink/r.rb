##
# SQL Relation builder lib
#
# this lib allows for chainably SQL-string growth with a simple
# standard ruby interface.
#
# Example usage:
#
#   Ink::R.select(:id, 'name').from(:tweets)
#   => "SELECT id, name FROM tweets"
#
# This means you can pick ANY method name and it will translate to
# an upcase SQL keyword.
# All method arguments will be transformed with #to_s and joined with
# a comma.
# Calling Ink::R.select will return an object of RelationString that
# supports the same ANY method logic.
#
#   Ink::R.where{ "(" + Ink::R(:id).is.null.or("id=5 ").to_sql + ")" }
#   => "WHERE ( id IS NULL OR id=5 )"
#
# The methods also support blocks which are required to return a string.
# Forcing an instance of RelationString to return the SQL is done by
# either #to_s or #to_sql.
# When it is required to start with an empty SQL, either use Ink::R()
# or instance Ink::R::RelationString.new by hand.
#
#   Ink::R::RelationString.new("foo").to_s
#   => "foo"
#
# RelationString.new takes one argument, the initial SQL string.
#

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
