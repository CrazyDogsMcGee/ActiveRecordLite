require_relative 'db_connection'
require_relative '01_sql_object'
require_relative '05_relation'

module Searchable
  
  def where(params)
    queries = params.values
    where_conditions = params.keys.map {|attr| "#{attr} = ?"}
    
    query_result = DBConnection.execute(<<-SQL, *queries)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_conditions.join(" AND ")}
    SQL
    
    return self.parse_all(query_result)
    
    #Relation.new(where_conditions, queries, self)
  end
  
end

class SQLObject
  extend Searchable
end
