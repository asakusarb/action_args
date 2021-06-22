class <%= controller_class_name %>Controller < ApplicationController
<% if defined? ActionController::StrongParameters -%>
  permits <%= attributes.map {|a| ":#{a.name}" }.join(', ') %>

<% end -%>
  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    render json: <%= "@#{plural_table_name}" %>
  end

  # GET <%= route_url %>/1
  def show(id)
    @<%= singular_table_name %> = <%= orm_class.find(class_name, 'id') %>

    render json: <%= "@#{singular_table_name}" %>
  end

  # POST <%= route_url %>
  def create(<%= singular_table_name %>)
    @<%= singular_table_name %> = <%= orm_class.build(class_name, singular_table_name) %>

    if @<%= orm_instance.save %>
      render json: <%= "@#{singular_table_name}" %>, status: :created, location: <%= "@#{singular_table_name}" %>
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  # PUT <%= route_url %>/1
  def update(id, <%= singular_table_name %>)
    @<%= singular_table_name %> = <%= orm_class.find(class_name, 'id') %>

<% if orm_instance.respond_to? :update -%>
    if @<%= orm_instance.update(singular_table_name) %>
<% else -%>
    if @<%= orm_instance.update_attributes(singular_table_name) %>
<% end -%>
      render json: <%= "@#{singular_table_name}" %>
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  # DELETE <%= route_url %>/1
  def destroy(id)
    @<%= singular_table_name %> = <%= orm_class.find(class_name, 'id') %>
    @<%= orm_instance.destroy %>
  end
end
