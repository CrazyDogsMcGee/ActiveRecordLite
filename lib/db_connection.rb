require 'sqlite3'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
CATS_SQL_FILE = File.join(ROOT_FOLDER, 'cats.sql')
CATS_DB_FILE = File.join(ROOT_FOLDER, 'cats.db')

puts ROOT_FOLDER

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{CATS_DB_FILE}'",
      "cat '#{CATS_SQL_FILE}' | sqlite3 '#{CATS_DB_FILE}'"  #pipes contents of cats.sql to a new cat.db in sqlite
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(CATS_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    puts args[0]

    instance.execute(*args) #returns db query
  end

  def self.execute2(*args)
    puts args[0]

    instance.execute2(*args) #returns db query, PLUS the names of the columns as the first column
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
