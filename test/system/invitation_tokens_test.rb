require "application_system_test_case"

class InvitationTokensTest < ApplicationSystemTestCase
  setup do
    @invitation_token = invitation_tokens(:one)
  end

  test "visiting the index" do
    visit invitation_tokens_url
    assert_selector "h1", text: "Invitation Tokens"
  end

  test "creating a Invitation token" do
    visit invitation_tokens_url
    click_on "New Invitation Token"

    fill_in "Created by", with: @invitation_token.created_by_id
    fill_in "Expired at", with: @invitation_token.expired_at
    fill_in "Token", with: @invitation_token.token
    click_on "Create Invitation token"

    assert_text "Invitation token was successfully created"
    click_on "Back"
  end

  test "updating a Invitation token" do
    visit invitation_tokens_url
    click_on "Edit", match: :first

    fill_in "Created by", with: @invitation_token.created_by_id
    fill_in "Expired at", with: @invitation_token.expired_at
    fill_in "Token", with: @invitation_token.token
    click_on "Update Invitation token"

    assert_text "Invitation token was successfully updated"
    click_on "Back"
  end

  test "destroying a Invitation token" do
    visit invitation_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invitation token was successfully destroyed"
  end
end
