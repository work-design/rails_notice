require "application_system_test_case"

class AnnunciationsTest < ApplicationSystemTestCase
  setup do
    @admin_annunciation = admin_annunciations(:one)
  end

  test "visiting the index" do
    visit admin_annunciations_url
    assert_selector "h1", text: "Annunciations"
  end

  test "creating a Annunciation" do
    visit admin_annunciations_url
    click_on "New Annunciation"

    fill_in "Body", with: @admin_annunciation.body
    fill_in "State", with: @admin_annunciation.state
    fill_in "Title", with: @admin_annunciation.title
    click_on "Create Annunciation"

    assert_text "Annunciation was successfully created"
    click_on "Back"
  end

  test "updating a Annunciation" do
    visit admin_annunciations_url
    click_on "Edit", match: :first

    fill_in "Body", with: @admin_annunciation.body
    fill_in "State", with: @admin_annunciation.state
    fill_in "Title", with: @admin_annunciation.title
    click_on "Update Annunciation"

    assert_text "Annunciation was successfully updated"
    click_on "Back"
  end

  test "destroying a Annunciation" do
    visit admin_annunciations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Annunciation was successfully destroyed"
  end
end
