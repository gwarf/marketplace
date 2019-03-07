# frozen_string_literal: true

require "rails_helper"

describe Jira::Client do
  let(:client) { Jira::Client.new }

  it "should Issuetype when calling mp_issue_type" do
    return_val = :issue_type
    expect(client).to receive_message_chain("Issuetype.find").with(client.jira_issue_type_id).and_return(return_val)
    expect(client.mp_issue_type).to equal(return_val)
  end

  it "should find Project when calling mp_project" do
    return_val = :project
    expect(client).to receive_message_chain("Project.find").with(client.jira_project_key).and_return(return_val)
    expect(client.mp_project).to equal(return_val)
  end

  it "create_service issue should save issue with correct fields" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("ROOT_URL").and_return("https://mp.edu")

    user = create(:user, first_name: "John", last_name: "Doe", uid: "uid1")
    project_item = create(:project_item,
                          affiliation: create(:affiliation,
                                              user: user,
                                              organization: "organization 1",
                                              department: "department 1",
                                              email: "john.doe@organization.com", webpage: "http://organization.com",
                                              supervisor: "Jim Supervisor",
                                              supervisor_profile: "http://jim.supervisor.edu"),
                          offer: create(:offer, name: "off1", service: create(:service,
                                                                        title: "s1",
                                                                        categories: [create(:category, name: "cat1")])),
                          user_group_name: "User Group Name 1",
                          project_name: "My Secret Project",
                          project: create(:project, user: user, name: "My Secret Project"),
                          customer_typology: "single_user",
                          research_area: create(:research_area, name: "My RA"),
                          access_reason: "some reason", properties: [
            {
                "id": "id1",
                "type": "input",
                "label": "Data repository name",
                "value": "aaaaaa",
                "value_type": "string",
                "description": "Type data repository name" },
            {
                "id": "id2",
                "type": "select",
                "label": "Harvesting method",
                "value": "OAI-PMH",
                "config": { "mode": "buttons", "values": ["OAI-PMH", "JSON-API", "CSW 2.0", "Other"] },
                "value_type": "string",
                "description": "Choose harvesting method"
            },
            {
                "id": "id3",
                "type": "input",
                "label": "Harvesting endpoint",
                "value": "aaaaa",
                "value_type": "string",
                "description": "Type harvesting endpoint" }
        ])

    expected_fields = { summary: "Service order, John Doe, s1",
                       project: { key: "MP" },
                       issuetype: { id: 10000 },
                       "Order reference-1" => Rails.application.routes.url_helpers.project_item_url(id: project_item.id,
                                                                                                    host: "https://mp.edu"),
                       "CI-Name-1" => "John",
                       "CI-Surname-1" => "Doe",
                       "CI-Email-1" => "john.doe@organization.com",
                       "CI-DisplayName-1" => "John Doe",
                       "CI-EOSC-UniqueID-1" => "uid1",
                       "CI-Institution-1" => "organization 1",
                       "CI-Department-1" => "department 1",
                       "CI-DepartmentalWebPage-1" => "http://organization.com",
                       "CI-SupervisorName-1" => "Jim Supervisor",
                       "CI-SupervisorProfile-1" => "http://jim.supervisor.edu",
                       "CP-CustomerTypology-1" => { "id" => "20000" },
                       "CP-ReasonForAccess-1" => "some reason",
                       "CP-UserGroupName-1" => "User Group Name 1",
                       "CP-ProjectInformation-1" => "My Secret Project",
                       "SO-ProjectName-1" => "My Secret Project (#{project_item.project.id})",
                       "CP-ScientificDiscipline-1" => "My RA",
                       "CP-Platforms-1" => "",
                       "CP-INeedAVoucher-1" => { "id" => "20004" },
                       "CP-VoucherID-1" => "",
                       "SO-1-1" => "cat1/s1/off1?Data repository name=aaaaaa&" +
                                   "Harvesting method=OAI-PMH&" +
                                   "Harvesting endpoint=aaaaa",
                       "SO-ServiceOrderTarget-1" => "",
                       "SO-OfferType-1" => { "id" => "20005" } }

    issue = double(:Issue)
    expect(issue).to receive("save").with(fields: expected_fields).and_return(true)
    expect(client).to receive_message_chain("Issue.build").and_return(issue)

    expect(client.create_service_issue(project_item)).to be(issue)
  end

  it "create_service open access issue should save issue with correct fields" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("ROOT_URL").and_return("https://mp.edu")

    user = create(:user, first_name: "John", last_name: "Doe", uid: "uid2", affiliations: [])
    project_item = create(:project_item,
                          customer_typology: nil,
                          access_reason: nil,
                          additional_information: nil,
                          affiliation: nil,
                          user_group_name: nil,
                          project_name: nil,
                          offer: create(:offer, name: "off1",  service: create(:service,
                                                                               order_target: "email@domain.com",
                                                                               title: "s1",
                                                                               service_type: "open_access",
                                                                               connected_url:  "http://service.org/access",
                                                                               categories: [create(:category, name: "cat1")])),
                          research_area: nil,
                          project: create(:project, user: user, name: "My Secret Project"))

    expected_fields = { summary: "Service order, John Doe, s1",
                        project: { key: "MP" },
                        issuetype: { id: 10000 },
                        "Order reference-1" => Rails.application.routes.url_helpers.project_item_url(id: project_item.id,
                                                                                                     host: "https://mp.edu"),
                        "CI-Name-1" => "John",
                        "CI-Surname-1" => "Doe",
                        "CI-DisplayName-1" => "John Doe",
                        "CI-EOSC-UniqueID-1" => "uid2",
                        "CP-Platforms-1" => "",
                        "CP-INeedAVoucher-1" => { "id" => "20004" },
                        "CP-VoucherID-1" => "",
                        "SO-ProjectName-1" => "My Secret Project (#{project_item.project.id})",
                        "SO-1-1" => "cat1/s1/off1?",
                        "SO-ServiceOrderTarget-1" => "email@domain.com",
                        "SO-OfferType-1" => { "id" => "20006" } }


    issue = double(:Issue)
    expect(issue).to receive("save").with(fields: expected_fields).and_return(true)
    expect(client).to receive_message_chain("Issue.build").and_return(issue)

    expect(client.create_service_issue(project_item)).to be(issue)
  end

  it "create_service open access with voucher id" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("ROOT_URL").and_return("https://mp.edu")

    user = create(:user, first_name: "John", last_name: "Doe", uid: "uid2", affiliations: [])
    project_item = create(:project_item,
                          customer_typology: nil,
                          access_reason: nil,
                          additional_information: nil,
                          affiliation: nil,
                          user_group_name: nil,
                          project_name: nil,
                          offer: create(:offer,
                                        name: "off1",
                                        voucherable: true,
                                        service: create(:service,
                                                                 title: "s1",
                                                                 service_type: "open_access",
                                                                 connected_url:  "http://service.org/access",
                                                                 categories: [create(:category, name: "cat1")])),
                          research_area: nil,
                          voucher_id: "123123",
                          project: create(:project, user: user, name: "My Secret Project"))

    expected_fields = { summary: "Service order, John Doe, s1",
                        project: { key: "MP" },
                        issuetype: { id: 10000 },
                        "Order reference-1" => Rails.application.routes.url_helpers.project_item_url(id: project_item.id,
                                                                                                     host: "https://mp.edu"),
                        "CI-Name-1" => "John",
                        "CI-Surname-1" => "Doe",
                        "CI-DisplayName-1" => "John Doe",
                        "CI-EOSC-UniqueID-1" => "uid2",
                        "CP-Platforms-1" => "",
                        "CP-INeedAVoucher-1" => { "id" => "20004" },
                        "CP-VoucherID-1" => "123123",
                        "SO-ProjectName-1" => "My Secret Project (#{project_item.project.id})",
                        "SO-1-1" => "cat1/s1/off1?",
                        "SO-ServiceOrderTarget-1" => "",
                        "SO-OfferType-1" => { "id" => "20006" } }

    issue = double(:Issue)
    expect(issue).to receive("save").with(fields: expected_fields).and_return(true)
    expect(client).to receive_message_chain("Issue.build").and_return(issue)

    expect(client.create_service_issue(project_item)).to be(issue)
  end

  it "create_service open access requesting vouchers" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("ROOT_URL").and_return("https://mp.edu")

    user = create(:user, first_name: "John", last_name: "Doe", uid: "uid2", affiliations: [])
    project_item = create(:project_item,
                          customer_typology: nil,
                          access_reason: nil,
                          additional_information: nil,
                          affiliation: nil,
                          user_group_name: nil,
                          project_name: nil,
                          offer: create(:offer,
                                        name: "off1",
                                        voucherable: true,
                                        service: create(:service,
                                                                 title: "s1",
                                                                 service_type: "open_access",
                                                                 connected_url:  "http://service.org/access",
                                                                 categories: [create(:category, name: "cat1")])),
                          research_area: nil,
                          request_voucher: true,
                          project: create(:project, user: user, name: "My Secret Project"))

    expected_fields = { summary: "Service order, John Doe, s1",
                        project: { key: "MP" },
                        issuetype: { id: 10000 },
                        "Order reference-1" => Rails.application.routes.url_helpers.project_item_url(id: project_item.id,
                                                                                                     host: "https://mp.edu"),
                        "CI-Name-1" => "John",
                        "CI-Surname-1" => "Doe",
                        "CI-DisplayName-1" => "John Doe",
                        "CI-EOSC-UniqueID-1" => "uid2",
                        "CP-Platforms-1" => "",
                        "CP-INeedAVoucher-1" => { "id" => "20003" },
                        "CP-VoucherID-1" => "",
                        "SO-ProjectName-1" => "My Secret Project (#{project_item.project.id})",
                        "SO-1-1" => "cat1/s1/off1?",
                        "SO-ServiceOrderTarget-1" => "",
                        "SO-OfferType-1" => { "id" => "20006" } }

    issue = double(:Issue)
    expect(issue).to receive("save").with(fields: expected_fields).and_return(true)
    expect(client).to receive_message_chain("Issue.build").and_return(issue)

    expect(client.create_service_issue(project_item)).to be(issue)
  end

end
