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
    
    self.parse_all(table_data)
  end

  def self.parse_all(results)
    all_instances = []
    
    results.each do |hash|
      all_instances.push(self.new(hash))
    end
    
    all_instances
  end

  def self.find(id)
    query = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL
    
    return self.parse_all(query).first
  end

  def initialize(params = {})
    db_column = self.class.columns
    
    params.each do |key, val|
      unless db_column.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end
    end
    
    params.each do |key,val|
      method_sym = key
      eq_method = (method_sym.to_s + "=").to_sym
      self.send(eq_method, val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    column_names = self.class.columns
    attributes = column_names.map {|attr_name| self.send(attr_name)}
    return attributes
  end

  def insert
    column_names = self.class.columns[1..-1].join(",")
    attributes = (["?"] * @attributes.length).join(",")
    
    DBConnection.execute(<<-SQL, *attribute_values[1..-1])
      INSERT INTO
        #{self.class.table_name} (#{column_names})
      VALUES
        (#{attributes})
    SQL
    
    self.send(:id=, DBConnection.last_insert_row_id)
  end

  def update
    eql_attrs = self.class.columns[1..-1].map {|attr| "#{attr}=?"}.join(",")

    DBConnection.execute(<<-SQL, *attribute_values[1..-1], attribute_values[0])
      UPDATE
        #{self.class.table_name}
      SET
        #{eql_attrs}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id.nil? ? self.insert : self.update
  end
  
end


