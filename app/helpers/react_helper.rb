require "securerandom"

module ReactHelper
  def react_component(component_name, props = {})
    random_id = SecureRandom.alphanumeric(8)
    tag.div(class: "react-component-#{random_id}", data: { "component-name": component_name, props: props })
  end
end
