require 'test_helper'

class SendersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sender = senders(:one)
  end

  test "should get index" do
    get senders_url
    assert_response :success
  end

  test "should get new" do
    get new_sender_url
    assert_response :success
  end

  test "should create sender" do
    assert_difference('Sender.count') do
      post senders_url, params: { sender: { admin: @sender.admin, client_id: @sender.client_id, email: @sender.email, password_digest: @sender.password_digest } }
    end

    assert_redirected_to sender_url(Sender.last)
  end

  test "should show sender" do
    get sender_url(@sender)
    assert_response :success
  end

  test "should get edit" do
    get edit_sender_url(@sender)
    assert_response :success
  end

  test "should update sender" do
    patch sender_url(@sender), params: { sender: { admin: @sender.admin, client_id: @sender.client_id, email: @sender.email, password_digest: @sender.password_digest } }
    assert_redirected_to sender_url(@sender)
  end

  test "should destroy sender" do
    assert_difference('Sender.count', -1) do
      delete sender_url(@sender)
    end

    assert_redirected_to senders_url
  end
end
