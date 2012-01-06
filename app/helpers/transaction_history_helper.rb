module TransactionHistoryHelper
  def row_class(order_detail)
    needs_reconcile_warning?(order_detail) ? 'reconcile-warning' : ''
    # if @warning_method
      # @warning_method.call(self, order_detail) ? 'reconcile-warning' : ''
    # else
      # ''
    # end
  end
  
  def product_options(products, search_fields)
    options = []
    products.each do |product|
      selected = search_fields && search_fields.include?(product.id.to_s) ? "selected = \"selected\"" : ""
      options << "<option value=\"#{product.id}\" data-facility=\"#{product.facility.id}\" #{selected}>#{product.name}</option>"
    end
    options.join("\n").html_safe
    #options_from_collection_for_select(products, "id", "name", search_fields)
  end
  
  def chosen_field(field, label, value_field = "id", label_field = "name", from_collection = nil)
    var = instance_variable_get("@#{field}")
    enabled = var && var.size > 1 
    html = "<li class=\"#{enabled ? '' : 'disabled'}\">"
    html << (label_tag field, label.pluralize)
    
    from_collection ||=  options_from_collection_for_select(var, value_field, label_field, @search_fields[field])
    options = {:multiple => true, :"data-placeholder" => "Select #{label.pluralize.downcase}"}
    options.merge!({:disabled => :disabled}) unless enabled
    html << (select_tag field, from_collection, options)
    html << "</li>"
    html.html_safe
  end
  
end
