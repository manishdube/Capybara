require 'spec_helper'


feature "Main page test: ", :nightly,:ui, driver: :selenium do

  given(:prj) {'.//*[contains(@class,"dropdown")]/ul/li/a'}
  given(:dropdown_default_project) {'.//*[@class="btn"]/p[1]'}
  given(:tabs_menu) {'.//*[@class="menu"]'}
  given(:dashboard) {"#{tabs_menu}/a[1]"}
  given(:utilities) {"#{tabs_menu}/a[2]"}
  given(:bulk_tagging) {"#{tabs_menu}/a[3]"}
  given(:hud_button){'//*[@id="hud_button"]'}
  given(:latest_actvty) {'//*[@class="switch"]'}
  given(:project_tab) {"#{latest_actvty}/span[1]/a"}
  given(:monitors_tab) {"#{latest_actvty}/span[2]/a"}
  given(:scoutvision_home) {'.//*[@class="text"]/span/a'}
  given(:edit_button) {'.//*[@class="top_button"]'}
  given(:default_projects_table_path)  {'//*[@class="right_column"]/div/table/tbody/tr/td/div[1]'}
  given(:default_project_name) {"#{name}'s Project"}
  given(:login_logo) {'//*[@id="login_logo"]'}

 Steps " verify all links in main page work properly", with_steps:true do

    Given "that I am trying to login with an existing user" do
      login
    end

    Then 'I should see "ScoutVision Home"' do
      expect(find(:xpath,scoutvision_home).text).to have_content('ScoutVision Home')
    end

    Then 'I should see the correct platform Logo' do
      platfrom = SshClient.web.get_platform
      if platfrom == "scoutvision"
        expect(find(:xpath,login_logo)['src']).to have_content("ScoutVision166.png")
      elsif platfrom == "cloudscout"
        expect(find(:xpath,login_logo)['src']).to have_content("CloudScout166.png")
      elsif platfrom == "scoutvision_hosted"
        expect(find(:xpath,login_logo)['src']).to have_content("ScoutVisionHosted166.png")
      end
    end

    When 'I click on ScoutVison Home link' do
      find(:xpath,scoutvision_home).click
    end

    Then "I am back at the main page" do
      expect(page.current_url).to have_content(ENV['BASE_URL'])
    end

    Given "that I am in the main page " do
      expect(page.current_url).to have_content(ENV['BASE_URL'])
    end

    Then 'I see a tab named "Dashboard" ' do
      expect(find(:xpath,dashboard).text).to have_content("Dashboard")
    end

    Then 'I see a tab named "Utilities" ' do
      expect(find(:xpath,utilities).text).to have_content("Utilities")
    end

    Then 'I see a tab named "Bulk Tagging" ' do
      expect(find(:xpath,bulk_tagging).text).to have_content("Bulk Tagging")
    end

    Then 'I see a button named "CyberHUD" ' do
      expect(find(:xpath,hud_button).text).to have_content("CyberHUD")
    end

    Then 'I see a button named "edit" ' do
      expect(find(:xpath,edit_button).text).to have_content("edit")
    end

    Then 'I see a label that reads "Latest Activity" ' do
      expect(page).to have_content('Latest Activity')
    end

    Then 'I see a tab named "Project" ' do
      expect(find(:xpath,project_tab).text).to have_content("Project")
    end

    Then 'I see a tab named "Monitors" ' do
      expect(find(:xpath,monitors_tab).text).to have_content("Monitors")
    end

    Then 'I see a label that reads "Your Projects" ' do
      expect(page).to have_content('Your Projects')
    end

    Then "I see the user's default project under the 'Your Projects' label" do
      within '.right_column' do
        expect(page).to have_content default_project_name
      end
    end

    Then "I see the user's default project at the top of the project dropdown list" do
      hover_menu '#projects' do
        expect(page).to have_content default_project_name
      end
    end

    When 'I click on the Dashboard tab' do
       find(:xpath,dashboard).click
    end

    Then "I am back at the main page" do
      expect(page.current_url).to have_content(ENV['BASE_URL'])
    end

    When 'I click on the Utilities tab' do
       find(:xpath,utilities).click
    end

    Then 'I am taken to the "Utilities" page ' do
      expect(page.current_url).to have_content("/utilities")
      page.evaluate_script('window.history.back()')
    end

    When 'I click on the "Bulk Tagging" tab' do
       find(:xpath,bulk_tagging).click
    end

    Then 'I am taken to the "Bulk Tagging" page ' do
      expect(page.current_url).to have_content("/ip_taggings/create_many")
      page.evaluate_script('window.history.back()')
    end

    When 'click on the "edit" button' do
      find(:xpath,edit_button).click
    end

    Then 'I am taken to the edit page' do
      expect(page.current_url).to have_content('edit')
      page.evaluate_script('window.history.back()')
    end
  end
end
