# frozen_string_literal: true

FactoryBot.define do
  factory :eic_providers_response, class: Hash do
    skip_create
    initialize_with do
      # noinspection RubyStringKeysInHashInspection
      next {
          "total" => 2,
          "from" => 0,
          "to" => 2,
          "results" => [
              {
                  "id" => "bluebridge",
                  "name" => "BlueBRIDGE",
                  "website" => "https://www.bluebridge-vres.eu/",
                  "catalogueOfResources" => nil,
                  "publicDescOfResources" => nil,
                  "logo" => nil,
                  "additionalInfo" => "-",
                  "contactInformation" => nil,
                  "users" => nil,
                  "active" => true,
                  "status" => "approved"
              },
              {
                  "id" => "phenomenal",
                  "name" => "Phenomenal",
                  "website" => "http://phenomenal-h2020.eu/home/",
                  "catalogueOfResources" => nil,
                  "publicDescOfResources" => nil,
                  "logo" => "http://phenomenal-h2020.eu/home/wp-content/uploads/2016/06/PhenoMeNal_logo.png",
                  "additionalInfo" => "-",
                  "contactInformation" => "",
                  "users" => nil,
                  "active" => true,
                  "status" => "approved"
              },
              {
                  "id" => "West-Life",
                  "name" => "World-wide E-infrastructure for structural biology",
                  "website" => "https://west-life.eu",
                  "catalogueOfResources" => "https://bio.tools/",
                  "publicDescOfResources" => "https://about.west-life.eu/network/west-life/services",
                  "logo" => "https://about.west-life.eu/network/west-life/about/templates/westlife/images/west-life.png",
                  "additionalInfo" => "https://about.west-life.eu/network/west-life/about/project. For more information contact chris.morris@stfc.ac.uk",
                  "contactInformation" => "+44 1925 603689",
                  "users" => nil,
                  "active" => true,
                  "status" => "approved"
              }
          ],
          "facets" => [
              {
                  "field" => "resourceType",
                  "label" => "Resource Type",
                  "values" => [
                      {
                          "value" => "provider",
                          "label" => nil,
                          "count" => 21
                      }
                  ]
              }
          ]
      }
    end
  end
end
