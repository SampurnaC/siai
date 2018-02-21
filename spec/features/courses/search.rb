require 'rails_helper'

context "Find key by your search scope" do
  before(:each) do
    @user = FactoryBot.create(:user)
    @course = FactoryBot.create(:course)
    sign_in @user
  end

  feature 'search user' do
    scenario "find with attribute name" do
      visit students_courses_path
      fill_in 'search', with: @course.name
      click_button 'Buscar'
      expect(page).to have_content(@course.name)
    end

    scenario "find with fail attribute" do
      visit students_courses_path
      fill_in 'search', with: 'wrong_attribute'
      click_button 'Buscar'
      expect(page).to have_content("Sua busca por wrong_attribute não obteve resutados")
    end
  end
end
