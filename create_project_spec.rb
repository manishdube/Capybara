require 'spec_helper'

feature "Create a project", :ui, :pawn, :nightly do
  given(:project_name) {"My really special project"}

  after do
    remove_project project_name rescue nil
  end

  Steps "works" do
    include_steps 'login'

    Given 'I am on the new project page' do
      # Click the Admin link
      click_admin_link

      click_menu_link 'Projects'

      click_link 'new project'
    end

    When 'I enter invalid information' do
      click_button 'Save Project'
    end

    Then 'I should see validation errors' do
      expect(page).to have_content "Name is too short"
    end

    When 'I enter valid information' do
      create_project project_name, pawn_username, pawn_name
    end

    Then 'the project is created' do
      expect(page).to have_content project_name
    end

    When 'I login as the project user' do
      login_as_pawn
    end

    Then 'I should have access to the project' do
      hover_menu '#projects' do
        expect(page).to have_content project_name
      end
    end
  end
end
