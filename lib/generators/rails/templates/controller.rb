class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
<% if defined? ActionController::StrongParameters -%>
  permits <%= attributes.map {|a| ":#{a.name}" }.join(', ') %>

<% end -%>
  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create(<%= singular_table_name %>)
    @<%= singular_table_name %> = <%= orm_class.build(class_name, singular_table_name) %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: '<%= human_name %> was successfully created.'
    else
      render :new
    end
  end

  # PUT <%= route_url %>/1
  def update(<%= singular_table_name %>)
<% if orm_instance.respond_to? :update -%>
    if @<%= orm_instance.update(singular_table_name) %>
<% else -%>
    if @<%= orm_instance.update_attributes(singular_table_name) %>
<% end -%>
      redirect_to @<%= singular_table_name %>, notice: '<%= human_name %> was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>

    redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>(id)
      @<%= singular_table_name %> = <%= orm_class.find(class_name, 'id') %>
    end
end
