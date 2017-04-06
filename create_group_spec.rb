require 'spec_helper'

# FIXME: Blocked by D-2552
feature 'Create a group', :ui, :pawn, :blocked do
  let(:project) {'Group test project'}
  let(:group)   {'Test Group'}

  background do
    # make sure the pawn does not have access to the project
    login_as_pawn
    within('#projects') do
      skip "Pawn has access to proejct '#{project}', but should not" if page.has_content?(project)
    end

    # make sure no other project is named this
    login
    visit 'projects'
    skip "Project '#{project}' already exists." if page.has_content?(project)

    begin
      create_project project, username
    rescue => e
      skip e.to_s
    end
  end

  after do
    remove_project project rescue nil
    remove_group group rescue nil
  end

  # TODO: move this to the UI module
  def remove_group(name)
    visit 'groups'
    click_link name

    page.accept_alert do
      click_button 'group_delete'
    end
  end

  Steps 'works' do
    include_steps 'login'

    Given 'I am on the new group page' do
      click_admin_link

      click_menu_link 'Groups'

      click_link 'new group'
    end

    When 'I save an invalid group' do
      click_button 'Save'
    end

    Then 'I get an error' do
      expect(page).to have_content "Name is too short"
    end


    When 'I save a valid group' do
      fill_in 'Group Name', with: group
      select contract, from: 'contract'

      # fill in an admin
      fill_in_autocomplete 'autocomplete_input', with: pawn_username

      click_button 'Save'
    end

    Then 'I see the group' do
      expect(page).to have_content group
    end


    When 'I add the group to a project' do
      visit 'projects'
      click_link project

      fill_in_autocomplete 'autocomplete_group_input', with: group
      click_button 'Save Project'
    end

    Then 'I see the group in the project' do
      visit 'projects'
      click_link project

      within '#project_groups' do
        expect(page).to have_content group
      end
    end


    When 'I login as the pawn' do
      login_as_pawn
    end

    Then 'I should have access to the project' do
      hover_menu '#projects' do
        expect(page).to have_content project
      end
    end
  end
end
