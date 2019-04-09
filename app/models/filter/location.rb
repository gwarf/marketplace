# frozen_string_literal: true

class Filter::Location < Filter
  def initialize(params = {})
    super(params: params.fetch(:params, {}),
          field_name: "location", type: :select,
          title: "Provider location")
  end

  private

    def fetch_options
      [["Any", ""], ["EU", "EU"]]
    end

    def do_call(services)
      services
    end
end