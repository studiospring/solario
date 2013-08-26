module ApplicationHelper

  #return full title on a per-page basis
  def full_title(page_title)# <<<
    base_title = "Solario"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end# >>>
  #see railscast #197
  def link_to_add_fields(name, f, association)# <<<
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end# >>>
end
