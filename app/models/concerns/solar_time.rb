#add "include SolarTime" to model
#To use this module, the base class must have a longitude attribute
module SolarTime
  require 'core_ext/numeric'
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods# <<<
    #refactor 'B' variable used in EoT and declination methods
    #return radians
    def b(day)# <<<
      b = (360 / 365.0)*(day - 81).to_rad
    end# >>>
    #return Equation of Time in minutes
    def eot(day)# <<<
      b = self.b(day)
      eot = 9.87 * Math.sin(2 * b) - 7.53 * Math.cos(b) - 1.5 * Math.sin(b)
    end# >>>
    #convert EST to local solar time
    def to_lst# <<<
      lst = local_time + (self.time_correction_factor() / 60)
    end# >>>
  end# >>>

  #add instance methods here
  
  #returns parent object of instance related by "has_child"
  def parent# <<<
    query = Neo4j._query("START child=node(#{self.id})
                          MATCH (parent)-[:has_child]->(child)
                          RETURN parent")
    parent = query.first
    #return nil if no parent exists
    begin
      return parent[:parent]
    rescue NoMethodError
      return parent
    end
  end# >>>
  #returns array of children in object form (i.e. direct descendants)
  def children(relationship, child)# <<<
    query = Neo4j._query("START parent=node(#{self.id})
                          MATCH (parent)-[:#{relationship}]->(#{child})
                          RETURN #{child}")
    #need to convert child to symbol, eg child -> node_object[:child]
    children_array = query.collect { |node_object| node_object[child.to_sym] }
  end# >>>
  #update outgoing relationships to child nodes (i.e. direct descendants)
  #e.g. @vclass.update_rels('has', 'subclass', [1, 3, ""])
  #child_ids accepts string for one node or array for multiple nodes
  def update_rels(relationship, child, child_ids)# <<<
    #convert to array, if string
    child_ids_array = Array.new
    if child_ids.class == String
      child_ids_array[0] = child_ids
    elsif child_ids.present?
      child_ids_array = child_ids
    end
    #remove blank values
    child_ids_array.delete_if { |id| id == "" }
    #update "has" relationship to childes
    existing_child_ids = self.children(relationship, child).collect { |child_node| child_node.id }
    if child_ids_array.empty?
      unless existing_child_ids.empty?
        self.rels(:outgoing, relationship.to_sym).delete_all
      end
    else
      ids_to_delete = existing_child_ids - child_ids_array
      ids_to_add = child_ids_array - existing_child_ids
      model = child.capitalize.constantize

      ids_to_delete.each do |id|
        child_node = model.find(id)
        self.send(relationship).delete(child_node)
      end

      #prevent duplicate relationships
      #ids_to_add.uniq!
      ids_to_add.uniq.each do |id|
        child_node = model.find(id)
        #ensure that only the specified objects are given a relationship
        unless child_node.nil?
          self.outgoing(relationship.to_sym) << child_node
        end
      end

    end
  end# >>>
end
