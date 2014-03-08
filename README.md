
# SQL Relation builder lib

This lib allows for chainable SQL-string growth with a simple
standard ruby interface.


## Example usage:

```ruby
  Ink::R.select(:id, 'name').from(:tweets)
  => "SELECT id, name FROM tweets"
```

This means you can pick ANY method name and it will translate to
an upcase SQL keyword.
All method arguments will be transformed with **#to_s** and joined
with a comma.
Calling Ink::R.select will return an object of RelationString that
supports the same ANY method logic.

```ruby
  Ink::R.where(:id){ |r| r.is.null.or("id=5") }
  => " WHERE id IS NULL OR id=5"
```

The methods also support blocks that receive an empty RelationString
object and the result is automatically converted to a string.
Forcing an instance of RelationString to return the SQL is done by
either **#to_s** (aliases: **#to_str** **#to_sql**).


## Advanced SQL

Special characters are _ and ! which are detected as suffix of the
methods. Examples are **where!**, **max_** or **select_!**.
Each character brings special properties. An ! forces the arguments
into brackets:

```ruby
  Ink::R.where!(:id)
  => " WHERE (id)"
```

An _ removes the leading space for the first argument:

```ruby
  Ink::R.where_(:id, :name)
  => " WHEREid, name"
```

Both characters (the order is irrelevant, but the ruby way suggests
it to be _!) remove the method prefix space and simulate a function
call:

```ruby
  Ink::R.max_!(:id)
  => "MAX(id)"

  Ink::R.select{ |r| r.max_!(:id) }
  => " SELECT MAX(id)"
```

When dealing with unions and the like, it might sometimes be preferable
to start with a bracket. Use the R! method:

```ruby
  Ink::R!{ |r| r.select(:id).from(:x) }.union!{ |r| r.select(:id).from(:y) }
  => "( SELECT id FROM x) UNION ( SELECT id FROM y)"
```

When it is required to start with an empty SQL instance
Ink::R::RelationString.new by hand.

  Ink::R::RelationString.new("foo").to_s
  => "foo"

RelationString.new takes one argument, the initial SQL string.

