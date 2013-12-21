require 'spec_helper'

<% module_namespacing do -%>
describe <%= class_name %> do
  pending "add some examples to (or delete) #{__FILE__}"
  before { @<%= singular_table_name %> = <%= table_name %>.new() }
  subject { @<%= singular_table_name %> }

  <% attributes.each do |attribute| -%>
    it { should respond_to(:<%= attribute.name %>) }       
  <% end -%>
end
<% end -%>
