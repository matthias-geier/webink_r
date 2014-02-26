
= SQL Relation builder lib

this lib allows for chainable SQL-string growth with a simple
standard ruby interface.

== Example usage:

  Ink::R.select(:id, 'name').from(:tweets)
  => "SELECT id, name FROM tweets"

This means you can pick ANY method name and it will translate to
an upcase SQL keyword.
All method arguments will be transformed with #to_s and joined with
a comma.
Calling Ink::R.select will return an object of RelationString that
supports the same ANY method logic.

  Ink::R.where{ "(" + Ink::R(:id).is.null.or("id=5 ").to_sql + ")" }
  => "WHERE ( id IS NULL OR id=5 )"

The methods also support blocks which are required to return a string.
Forcing an instance of RelationString to return the SQL is done by
either #to_s or #to_sql.
When it is required to start with an empty SQL, either use Ink::R()
or instance Ink::R::RelationString.new by hand.

  Ink::R::RelationString.new("foo").to_s
  => "foo"

RelationString.new takes one argument, the initial SQL string.

