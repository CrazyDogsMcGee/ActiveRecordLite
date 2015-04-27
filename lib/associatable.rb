require_relative 'searchable'
require 'active_support/inflector'
require 'pry'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.classify
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.downcase}_id".to_sym
    @class_name = options[:class_name] || name.classify
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name.to_s, options)
    belongs_to_options = assoc_options[name]
    
    define_method(name) {
      foreign_key = self.send(belongs_to_options.foreign_key)
      belongs_to_options.model_class.where(id: foreign_key).first
    }
  end

  def has_many(name, options = {})
    assoc_options[name] = HasManyOptions.new(name.to_s, self.to_s, options)
    has_many_options = assoc_options[name]
    
    define_method(name) {
      foreign_key = self.id
      has_many_options.model_class.where(has_many_options.foreign_key => foreign_key)
    }
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
