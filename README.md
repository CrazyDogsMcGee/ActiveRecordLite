Active Record Lite - A short implementation of a useful tool
-----
This implementation of ActiveRecord uses sql methods and metaprogamming to give Ruby classes access to database entries from an SQLite3 database.

## Implementation

### db_connection
The SQLObject class makes use of methods provided by the SQLite3 gem to make an initial connection to the database, through the DBConnection class.
The DBConnection class can execute SQL queries given to it and well as initializing the database through running backticked commands.

###SQLObject
This is the primary class through which the "ActiveRecord" transactions occur. 