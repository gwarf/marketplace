# frozen_string_literal: true

class Offer::Update
  def initialize(offer, params)
    @offer = offer
    @params = params
  end

  def call
    @offer.update(@params)
  end
end
