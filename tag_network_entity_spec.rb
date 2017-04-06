require 'spec_helper'

shared_steps 'entity tag' do
  include_steps 'login'

  When "I visit an network entity" do
    visit path
  end

  And "I add a tag" do
    fill_in_and_press_return tag_field, tag
  end

  Then "the tag should exist" do
    within(tag_list) do
      expect(page).to have_content(tag)
    end
  end

  When "I delete the tag" do
    within(:xpath, tag_row) do
      wait_and_click untag_btn
    end
  end

  Then "the tag should is removed" do
    expect(page).to have_no_content(tag)
  end
end

feature "Network entity tags",:ui, :nightly do
  given(:tag) {'as_tag_test'}
  given(:tag_field) {'add_tag'}
  given(:tag_list)  {'#tag_list'}
  given(:tag_row)   {".//td[contains(.,'#{tag}')]/.."} # Row containing the tag
  given(:untag_btn) {".//*[@class='delete']"}

  context 'for ASN' do
    given(:asn)  {'15169'} # google
    given(:path) {"/as/#{asn}"}

    Steps "can be created and deleted" do
      include_steps 'entity tag'
    end
  end

  context 'for IP' do
    given(:ip)   {'1.1.1.1'}
    given(:path) {"/ip/#{ip}"}

    Steps "can be created and deleted" do
      include_steps 'entity tag'
    end
  end

  context 'for CIDR' do
    given(:cidr) {"1.1.1.0/24"}
    given(:path) {"/cidr/#{cidr}"}

    Steps "can be created and deleted" do
      include_steps 'entity tag'
    end
  end

  context 'for FQDN' do
    given(:fqdn) {'google.com'}
    given(:path) {"/dns/#{fqdn}"}

    Steps 'can be created and deleted' do
      include_steps 'entity tag'
    end
  end

  context 'for country' do
    given(:country) {'US'}
    given(:path)    {"/country/#{country}"}

    Steps 'can be created and deleted' do
      include_steps 'entity tag'
    end
  end
end
