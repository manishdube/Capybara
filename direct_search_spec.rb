require 'spec_helper'


feature "direct search test", :nightly,:ui do

given(:quick_search) {'//*[@id="s_search"]'}
given(:tag_edit) {'//*[@id="add_tag"]'}
given(:as_on_screen) {'//*[@class="text"]/span'}
given(:tag_list) {'//*[@id="tag_list"]/tr'}
given(:no_tags) {'//*[@id="no_tags"]'}

 before do
   login
 end


 Steps "on an ip, yields the correct result", with_steps:true do
    Given "I enter an ip iin the quick search" do
      fill_in('s_search',:with => '1.1.1.1')
      find(:xpath, quick_search).native.send_keys(:return)
    end

    And "I push the enter key" do
      find(:xpath, quick_search).native.send_keys(:return)
      pry
    end

  end

 Steps "on a cidr, yields the correct result", with_steps:true do
    Given "that I am trying to login with an existing user" do
      login
    end
  end

  Steps "on an asn, yields the correct result", with_steps:true do
     Given "that I am trying to login with an existing user" do
       login
     end
   end


end
