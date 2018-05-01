require "application_system_test_case"

class NotifySettingsTest < ApplicationSystemTestCase
  setup do
    @notify_setting = notify_settings(:one)
  end

  test "visiting the index" do
    visit notify_settings_url
    assert_selector "h1", text: "Notify Settings"
  end

  test "creating a Notify setting" do
    visit notify_settings_url
    click_on "New Notify Setting"

    click_on "Create Notify setting"

    assert_text "Notify setting was successfully created"
    click_on "Back"
  end

  test "updating a Notify setting" do
    visit notify_settings_url
    click_on "Edit", match: :first

    click_on "Update Notify setting"

    assert_text "Notify setting was successfully updated"
    click_on "Back"
  end

  test "destroying a Notify setting" do
    visit notify_settings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Notify setting was successfully destroyed"
  end
end
