class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      string_name = name.to_s
      inst_var = "@#{string_name}".to_sym
      method_sym_eq = "#{string_name}=".to_sym
      
      define_method(name) {self.instance_variable_get(inst_var)}
      define_method(method_sym_eq) {|val| self.instance_variable_set(inst_var, val)}    
    end
  end
end
