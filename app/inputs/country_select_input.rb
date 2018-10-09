class CountrySelectInput < Formtastic::Inputs::CountryInput
  def to_html
    raise "To use the :country_select input, please install a country_select plugin, like this one: https://github.com/onomojo/i18n_country_select" unless builder.respond_to?(:country_code_select)
    input_wrapping do
      label_html <<
      builder.country_code_select(method, priority_countries, input_options, input_html_options)
    end
  end
end
