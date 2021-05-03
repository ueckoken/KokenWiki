require "test_helper"

class InvitationTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invitation_token = invitation_tokens(:one)
  end

  test "should get index" do
    get invitation_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_invitation_token_url
    assert_response :success
  end

  test "should create invitation_token" do
    assert_difference("InvitationToken.count") do
      post invitation_tokens_url, params: { invitation_token: { created_by_id: @invitation_token.created_by_id, expired_at: @invitation_token.expired_at, token: @invitation_token.token } }
    end

    assert_redirected_to invitation_token_url(InvitationToken.last)
  end

  test "should show invitation_token" do
    get invitation_token_url(@invitation_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_invitation_token_url(@invitation_token)
    assert_response :success
  end

  test "should update invitation_token" do
    patch invitation_token_url(@invitation_token), params: { invitation_token: { created_by_id: @invitation_token.created_by_id, expired_at: @invitation_token.expired_at, token: @invitation_token.token } }
    assert_redirected_to invitation_token_url(@invitation_token)
  end

  test "should destroy invitation_token" do
    assert_difference("InvitationToken.count", -1) do
      delete invitation_token_url(@invitation_token)
    end

    assert_redirected_to invitation_tokens_url
  end
end
