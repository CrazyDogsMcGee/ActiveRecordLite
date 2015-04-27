class Relation
  #Should this class have all the array methods?
  def initialize(stored_query, queries, table_name)
    @attr_names = stored_query
    @attrs = queries
    @obj_class = table_name
  end
  
  def where(attrs)
    attrs.each do |key,val|
      @attr_names.concat(["#{key}= ?"]) #should text real active record to see if conflixts exist if an attr is specified twice
      @attrs.concat([val])
    end
    
    return self
  end
  
  def length
    inspect.length
  end
  
  def inspect
    query_result = DBConnection.execute(<<-SQL, *@attrs)
      SELECT
        *
      FROM
        #{@obj_class.table_name}
      WHERE
        #{@attr_names.join(" AND ")}
    SQL
    
    return @obj_class.parse_all(query_result)
  end
 
  #http://www.theodinproject.com/ruby-on-rails/active-record-queries
end