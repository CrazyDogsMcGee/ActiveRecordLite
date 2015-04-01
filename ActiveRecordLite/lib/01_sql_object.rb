require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  
  def self.columns
    table_data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    
    table_data[0].map {|name| name.to_sym}
  end

  def self.finalize!
    self.columns.each do |method|
      string_name = method.to_s
      inst_var = "@".concat(string_name).to_sym
      method_eq = (string_name+"=").to_sym
      
      define_method(method) {self.attributes[method]}
      define_method(method_eq) {|val| self.attributes[method] = val}
      #Inside the define_method block, self refers to an instance...this is because instance_Eval is used to evaluate the block
    end    
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.tableize if !@table_name
    return @table_name
  end

  def self.all
    table_data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
  end

  def self.parse_all(results)
    r
  end

  def self.find(id)
  end

  def initialize(params = {})
    db_column = self.class.columns
    
    params.each do |key, val|
      unless db_column.include?(key)
        raise "unknown attribute '#{key}'"
      end
    end
    
    params.each do |key,val|
      eq_method = (key.to_s.concat("=")).to_sym
      self.send(eq_method, val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
  
end


