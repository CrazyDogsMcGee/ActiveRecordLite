require_relative 'associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) {
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name] #fetches leap-frogged association across through class. All references are from the 'viewpoint' of the through class
      
      query = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
      #{source_options.table_name} ON #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.table_name}.id
        WHERE
          #{through_options.table_name}.id = ?
      SQL
      
      source_options.model_class.parse_all(query).first
    }
  end
end
