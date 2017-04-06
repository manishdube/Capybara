require 'spec_helper'


feature "Help links", :admin, :nightly, :ui do

  def go_home_n_hover_on_question ()
    visit '/'
    find(help_menu).hover
  end

  given(:help_menu) {'#help'}
  given(:about_box) {'.//*[@id="version-content"]/div[2]'}

  Steps "work" do

    Given "that I am trying to login with an existing user" do
      login_as_admin
    end

    And 'I hover on the question mark on the navigation bar' do
      go_home_n_hover_on_question
    end

    Then "I see 5 options under the help dropdown" do
      within help_menu do
        items_in_list = all('li').size
        expect(items_in_list).to eq 5
      end
    end

    When 'I click on the guides option' do
      #clicking on the guides link opens a new window
      #to actually test I am there I have to switch to that window
      #windows is an array that contains all the windows open by my session
      click_link('Guides')
      switch_to_window(windows.last)
    end

    Then "I expect to be on the Lookingglass Product Documentation page" do
      expect(page).to have_content("Lookingglass Product Documentation")
    end

    When 'I click on the api-docs option' do
      go_home_n_hover_on_question
      click_link 'API Docs'
    end

    Then 'I am taken to the ScoutVision API Development Guide page' do
      expect(page).to have_content('ScoutVision API Development Guide')
    end

    When 'I click on the Feedback option' do
      go_home_n_hover_on_question
      click_link 'Feedback'
    end

    Then 'I am taken to the ScoutVision Feedback page' do
      expect(page).to have_content('Feedback')
    end

    When 'I click on the System info option' do
      go_home_n_hover_on_question
      click_link "System Info"
    end

    Then 'I am taken to the ScoutVision Feedback page' do
      expect(page).to have_content('ScoutVision Administration')
    end

    When 'I click on the about option' do
      go_home_n_hover_on_question
      click_link 'About'
    end

    Then 'I see the version and build information' do
      within(:xpath, about_box) do
        expect(page).to have_content 'VERSION: ScoutVision'
      end
    end

  end
end
