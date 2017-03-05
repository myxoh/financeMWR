module ActAsHash
  #This module allows an object with a defined @public_attributes
  #To have a set of attributes accesible 
  #(Assuming they are defined as attr_accessor 
  #or have getter and setter formulas)

  def [] attribute #Allows to access public instance variables 
    attribute = @public_attributes.select do |public_attribute| 
      public_attribute.to_s==attribute.to_s
    end #Should return just 1 value.
    self.send(attribute[0].to_s)
  end

  def []= attribute, value
    attribute = @public_attributes.select do |public_attribute| 
      public_attribute.to_s==attribute.to_s
    end #Should return just 1 value.
    self.send(attribute[0].to_s+"=", value)
  end
end