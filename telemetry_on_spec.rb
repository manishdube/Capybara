require 'spec_helper'


feature "Verify that some features are visible when telemetry is enabled:", :nightly,:ui, driver: :selenium do

  given(:prj) {'.//*[contains(@class,"dropdown")]/ul/li/a'}
  given(:dropdown_default_project) {'.//*[@class="btn"]/p[1]'}
  given(:tabs_menu) {'.//*[@class="menu"]'}
  given(:admin_menu) {'.//*[@class="menu"]'}
  given(:advanced) {'.//*[@class="menu"]/a[9]'}
  given(:telemetry_reports) {"#{tabs_menu}/a[2]"}
  given(:telemetry_report_page_label) {'.//*[@id="ad-hoc-box"]/label'}
  given(:account) {'.//*[@id="account"]'}
  given(:admin_menu_option) {"#{account}/ul/li[2]/a"}

  Steps "Reports tab" do
    Given "that telemetry is enabled" do
      skip "Telemetry is disabled" unless SshClient.web.telemetry_enabled?
    end

    And "that I am logged in with an existing user" do
      login
    end

    And 'I select a project' do
      find(:xpath,dropdown_default_project).click
    end

    Then "I see a Telemetry Reports option in menu bar" do
      expect(find(:xpath,telemetry_reports).text).to have_content("Telemetry Reports")
    end

    When "I click on the telemetry report menu option bar" do
       find(:xpath,telemetry_reports).click
    end

    Then "I know in the correct page because there is a label that reads  'Specify Report Scope (Country, AS, CIDR, IP, Tag, Domain)' " do
       expect(find(:xpath,telemetry_report_page_label).text).to have_content("Specify Report Scope (Country, AS, CIDR, IP, Tag, Domain)")
    end
  end

  Steps "Admin tab" do
    Given "that telemetry is enabled" do
      skip "Telemetry is disabled" unless SshClient.web.telemetry_enabled?
    end

    And "that I am logged in with an existing user" do
      login
    end

    And 'I select a project' do
      find(:xpath,dropdown_default_project).click
    end

    When "I hover on the account dropdown menu" do
      find(:xpath,account).hover
    end

    And "select the admin page menu item" do
      find(:xpath,admin_menu_option).click
    end

    Then "I see the advance menu item Advance" do
       expect(find(:xpath,advanced).text).to have_content("Advanced")
    end
  end
end
