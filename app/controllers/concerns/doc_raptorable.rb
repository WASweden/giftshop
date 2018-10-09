module DocRaptorable
  extend ActiveSupport::Concern

  included do
    layout "card"
  end

  private

  def doc_raptor_send(options = {})
    default_options = {
      name: controller_name,
      document_type: "pdf",
      test: Rails.env.production? ? Rails.application.secrets.docraptor_test_mode : true,
      javascript: true,
      prince_options: {
        media: "screen",
        baseurl: ENV['DOCRAPTOR_BASE_URL'],
      }
    }
    options = default_options.merge(options)
    options[:document_content] ||= render_to_string
    ext = options[:document_type].to_sym

    docraptor = DocRaptor::DocApi.new
    response = docraptor.create_doc(options)

    send_data response, :filename => "#{options[:name]}.#{ext}", :type => ext
  end
end
