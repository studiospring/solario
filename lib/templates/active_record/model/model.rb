<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>

<%- attributes each do |k, v| -%>
  validates <%- ":#{k}" -%>, presence: true
<%- end -%>

end
<% end -%>
