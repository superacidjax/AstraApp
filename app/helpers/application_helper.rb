module ApplicationHelper
  def link_to_add_fields(name, form, association, component:, state:, **args)
    # Create a new object for the association
    new_object = form.object.send(association).klass.new

    # Generate the fields for that object using fields_for
    fields = form.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(component.constantize.new(
        form_builder: builder,
        state: state,
        traits: @traits, # Add other dependencies
        client_applications: @client_applications,
        account: @account
      ))
    end

    # Insert the link to add the fields dynamically
    link_to(name, '#', class: "#{args[:class]} add_fields", data: { id: "new_#{association}", fields: fields.gsub("\n", "") })
  end
end
