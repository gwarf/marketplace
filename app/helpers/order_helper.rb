# frozen_string_literal: true

module OrderHelper
  def order_nav_link(title, path, state)
    content_tag(:li, class: "nav-item") do
      link_to_if(state != :disabled, title, path,
                 class: "nav-link #{"active" if state == :active}") do
        if state == :active
          content_tag(:a, title, class: "nav-link", href: "#",
                      onclick: "document.getElementById('order-form').submit();")
        else
          content_tag(:div, title, class: "nav-link disabled")
        end
      end
    end
  end

  def order_submit_options(step_key, orderable)
    if orderable && step_key == "summary"
      { form: "order-form", type: "submit", onclick: "_paq.push(['trackEvent', 'Service', 'Order']);" }
    elsif step_key == "summary"
      { form: "order-form", type: "submit", onclick: "_paq.push(['trackEvent', 'Service', 'AddToProject']);" }
    else
      { form: "order-form", type: "submit" }
    end
  end
end
