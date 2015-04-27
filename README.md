Active Record Lite - A short implementation of a useful tool
-----
This implementation of ActiveRecord uses sql methods and metaprogamming to give Ruby classes access to database entries from an SQLite3 database.

## Usage
To use out this ORM framework with a project, have your class inherit from "SQLObject" (Ex. class Foo < SQLObject). Don't forget to run the SQLObject::finalize!
method in your class definition! (see SQLObject below)

## Implementation

### db_connection
The SQLObject class makes use of methods provided by the SQLite3 gem to make an initial connection to the database, through the DBConnection class.
The DBConnection class can execute SQL queries given to it and well as initializing the database through running backticked commands.

### SQLObject
This is the primary class through which the "ActiveRecord" transactions occur. I use the "active_support/inflector" gem to get access to the 'tableize' method.
Primarily, the methods defined sql_object.rb are to instantiate an item from the database as a workable object or to save a new instance of the SQLObject class as
a database item. The SQLObject::finalize! method is also important as it defines all the getter and setter methods for the object class.

### Searchable
"searchable.rb" contains a module that extends the SQLObject class, allowing the "where" method to be used to search for matching table entries. It accomplishes this by
splitting the argument paramters provided and turning the key-value attribute pairs to SQL to be used in a query. The "where2" method returns an instance of a "Relation"
object that is meant to have chainable queries. (See 'Relation')

### Associtable
The "Associatable" module adds functionality to access database relations through referencing foreign keys and table joins in an SQL query. Like ActiveRecord for rails,
specifying "belongs_to" and "has_many" in the object class will automatically create all references to foreign keys and model names unless they are specified in the arguments
provided to the function. These references are stored in a "BelongsToOptions" or "HasManyOptions" object, which is used run an SQL query to fetch the correct information.
Each of these options are stored in a hash as a value, with the name of the associated model as the name. This hash is stored as an instance variable "@assoc_options" on 
the model defined.

For a model "Cat" where:

class Cat < SQLObject
  has_many :toys
  
  belongs_to :human
  
  has_one_through :home, :human, :house
end

The instance variable "@assoc_options" for Cat would look like this:

{
toys: #<BelongsToOptions:0x0300c868 @foreign_key=:toy_id, @class_name=Toy, @id=:id>
human: #<HasManyOptions:0x0300c868 @foreign_key=:human_id, @class_name=Human, @id=:id>
}

(The has_one_through method would simply use the options specified for human (and ON human) to make the query for the house)

And each of these objects would be invoked for the respective "Cat.toys" and "Cat.human" calls.

