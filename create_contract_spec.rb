require 'spec_helper'

feature "Create a contract", :admin, :ui, :nightly do
  given(:contract_name) {"My really special contract"}
  given(:org_name)      {"Special org"}

  def remove_contract(name)
    login_as_admin
    visit 'contracts'

    # delete the contract, if I can
    click_link contract_name
    page.accept_alert do
      click_button 'Delete Contract'
    end
  rescue
    # Don't care if it fails
  end

  after do
    remove_contract contract_name
  end

  Steps "works" do
    Given 'I am logged in as an admin' do
      login_as_admin
    end

    Given 'I am on the new contracts page' do
      # Click the Admin link
      find('#account').hover
      within('#account') do
        click_link 'Admin'
      end

      within('.menu') do
        click_link 'Contract'
      end

      click_link 'create contract'
    end

    When 'I enter invalid information' do
      click_button 'Save Contract'
    end

    Then 'I should see validation errors' do
      expect(page).to have_content "Name is too short"
      expect(page).to have_content "Organization is too short"
    end

    When 'I enter valid information' do
      fill_in 'Contract Name', with: contract_name
      fill_in 'Organization',  with: org_name
      click_button 'Save Contract'
    end

    Then 'the contract is created' do
      expect(page).to have_content contract_name
    end
  end
end
