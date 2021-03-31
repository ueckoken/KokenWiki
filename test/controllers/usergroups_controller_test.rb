require "test_helper"

class UsergroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usergroup = usergroups(:one)
  end

  test "should get index" do
    get usergroups_url
    assert_response :success
  end

  test "should get new" do
    get new_usergroup_url
    assert_response :success
  end

  test "should create usergroup" do
    assert_difference("Usergroup.count") do
      post usergroups_url, params: { usergroup: {} }
    end

    assert_redirected_to usergroup_url(Usergroup.last)
  end

  test "should show usergroup" do
    get usergroup_url(@usergroup)
    assert_response :success
  end

  test "should get edit" do
    get edit_usergroup_url(@usergroup)
    assert_response :success
  end

  test "should update usergroup" do
    patch usergroup_url(@usergroup), params: { usergroup: {} }
    assert_redirected_to usergroup_url(@usergroup)
  end

  test "should destroy usergroup" do
    assert_difference("Usergroup.count", -1) do
      delete usergroup_url(@usergroup)
    end

    assert_redirected_to usergroups_url
  end
end
