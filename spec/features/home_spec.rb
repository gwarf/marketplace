# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Home" do
  include OmniauthHelper

  scenario "searching should go to /services with correct query" do
    visit "/"

    fill_in "q", with: "Something"
    click_on(id: "query-submit")

    expect(page).to have_current_path(services_path, ignore_query: true)
    expect(page).to have_selector("#q[value='Something']")
  end

  context "services carousel" do
    let!(:service1) { create(:service, description: "published-service-1", status: :published) }
    let!(:service2) { create(:service, description: "published-service-2", status: :published) }
    let!(:service_draft) { create(:service, status: :draft) }

    it "should show only published service in Popular services section" do
      visit "/"
      expect(page).to have_text "Popular services"
      expect(page).to have_text(service1.title)
      expect(page).to have_text(service2.title)
      expect(page).not_to have_text(service_draft.title)
    end
  end

  context "lead_sections" do
    context "admin user" do
      let(:admin) { create(:user, roles: [:admin]) }
      before { checkin_sign_in_as(admin) }

      it "should see error" do
        visit "/"
        expect(page).to have_text("Cannot find lead_section with slug \"learn-more\"")
        expect(page).to have_text("Cannot find lead_section with slug \"use-cases\"")
      end

      it "should see section" do
        lead_section = create(:lead_section, slug: "learn-more", title: "Learn More Section")
        create(:lead, lead_section: lead_section)
        visit "/"
        expect(page).to_not have_text("Cannot find lead_section with slug \"learn-more\"")
        expect(page).to have_text("Cannot find lead_section with slug \"use-cases\"")
        expect(page).to have_text("Learn More Section")
      end
    end

    context "user" do
      let(:admin) { create(:user) }
      before { checkin_sign_in_as(admin) }

      it "should see error" do
        visit "/"
        expect(page).to_not have_text("Cannot find lead_section with slug \"learn-more\"")
        expect(page).to_not have_text("Cannot find lead_section with slug \"use-cases\"")
      end

      it "should see section" do
        lead_section = create(:lead_section, slug: "learn-more", title: "Learn More Section")
        create(:lead, lead_section: lead_section)
        visit "/"
        expect(page).to_not have_text("Cannot find lead_section with slug \"learn-more\"")
        expect(page).to_not have_text("Cannot find lead_section with slug \"use-cases\"")
        expect(page).to have_text("Learn More Section")
      end
    end
  end
end
