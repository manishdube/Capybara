require 'spec_helper'
require 'pry'

feature "Bulk tagging", :ui, :nightly do

  shared_steps 'visit bulk tagging' do
    include_steps 'login'

    Given 'I am on the bulk tagging page' do
      visit '/ip_taggings/create_many'
    end
  end

  given(:tag)    {'test'}
  given(:submit) {'tag-submit-button'}

  after do
    # TODO: This is done because it is too hard to remove a tag using the UI
    DB.new.del_tag tag
  end


  given(:tag_validation) {'#tag_validation'}
  given(:ip_validation)  {'#ips_and_fqdns_validation'}

  Steps "requires all fields to be populated" do
    include_steps 'visit bulk tagging'

    When "I submit an empty form" do
      click_button submit
    end

    Then "I should see an error on the tag field" do
      within tag_validation do
        expect(page).to have_content "This field is required."
      end
    end

    Then "I should see an error on the IP / FQDN field" do
      within ip_validation do
        expect(page).to have_content "This field is required."
      end
    end
  end


  given(:ip) {'1.1.1.1'}

  Steps "can tag IPs" do
    include_steps 'visit bulk tagging'

    When "I tag an IP" do
      fill_in 'ips_and_fqdns', with: ip
      fill_in 'Tag', with: tag
      click_button submit
    end

    Then "the IP count raises" do
      within '#results-ips-added' do
        expect(page).to have_content '1'
      end
    end

    And "the IP is tagged" do
      visit "/ip/#{ip}"
      within '#tag_list' do
        expect(page).to have_content tag
      end
    end
  end


  given(:fqdn) {'google.com'}

  Steps "can tag FQDNs" do
    include_steps 'visit bulk tagging'

    When 'I tag an FQDN' do
      fill_in 'ips_and_fqdns', with: fqdn
      fill_in 'Tag', with: tag
      click_button submit
    end

    Then 'the FQDN count raises' do
      within '#results-fqdn-added' do
        expect(page).to have_content '1'
      end
    end

    And 'the FQDN is tagged' do
      visit "/dns/#{fqdn}"
      within '#tag_list' do
        expect(page).to have_content tag
      end
    end
  end


  Steps "marks duplicated tags" do
    include_steps 'visit bulk tagging'

    When 'I tag multiple IP and FQDNS' do
      fill_in 'ips_and_fqdns', with: "#{ip}\n#{ip}\n#{fqdn}\n#{fqdn}\n#{fqdn}"
      fill_in 'Tag', with: tag
      click_button submit

      # it can take a while for the bulk tagging page to return
      wait_for do
        page.has_selector? '#results-ips-duplicate'
      end
    end

    Then 'it shows duplicates' do
      within '#results-ips-duplicate' do
        expect(page).to have_content '1'
      end

      within '#results-fqdn-duplicate' do
        expect(page).to have_content '2'
      end
    end
  end
end
