# frozen_string_literal: true

module ServiceHelper
  def print_rating_stars(rating)
    result = ""
    # full stars
    (0...rating.floor).each { result += content_tag(:i, "", class: "fas fa-star fa-lg") }

    # half stars
    result += content_tag(:i, "", class: "fas fa-star-half-alt fa-lg") if rating % 1 != 0

    # empty stars
    (0...5 - rating.ceil).each { result += content_tag(:i, "", class: "far fa-star fa-lg") }

    result.html_safe
  end

  def get_providers_list
    Provider.all
  end

  def any_present?(record, *fields)
    fields.map { |f| record.send(f) }.any? { |v| v.present? }
  end

  def get_terms_and_condition_hint_text(service)
    "You are about to order #{service.title} service. Please accept " \
      "#{link_to service.title, service.terms_of_use_url} terms and conditions to proceed.".html_safe
  end

  def dedicated_for_links(service)
    service.target_groups.map { |target| link_to(target.name, services_path(target_groups: target)) }
  end

  def dedicated_for_text(service)
    service.target_groups.map { |target| target.name }
  end

  def research_areas(service)
    service.research_areas.map { |target| link_to(target.name, services_path(research_areas: target)) }
  end

  def providers(service)
    service.providers.map { |target| link_to(target.name, services_path(providers: target)) }
  end

  def providers_text(service)
    service.providers.map { |target| target.name }
  end

  def highlighted_for(field, model, highlights)
    highlights&.dig(field)&.html_safe || model.send(field)
  end

  def service_logo(service)
    if service.logo.attached?
      image_tag service.logo.variant(resize: "100x70")
    else
      image_tag "eosc-img.png"
    end
  end
end
