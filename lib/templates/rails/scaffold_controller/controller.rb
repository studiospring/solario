<% module_namespacing do %>
class <%= controller_class_name %>Controller < ApplicationController
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
  end
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      flash[:success] = <%= "'New #{singular_table_name} created'" %>
      redirect_to @<%= singular_table_name %>
    else
      render "new"
    end
  end
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    if @<%= orm_instance.update_attributes("#{singular_table_name}_params") %>
      flash[:success] = <%= "'#{human_name} updated'" %>
      redirect_to @<%= singular_table_name %>
    else
      render "edit"
    end
  end
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url
  end
  private
    def <%= singular_table_name %>_params
      #enter mass assignable fields here
      params.require(:<%= singular_table_name %>).permit()
    end 
end
<% end %>
