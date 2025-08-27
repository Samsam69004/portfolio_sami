# test/controllers/contacts_controller_test.rb
require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "contact section is reachable on home" do
    get root_url
    assert_response :success
  end

  test "should create contact and redirect to anchor" do
    # par défaut en test, delivery_method = :test -> pas d'envoi SMTP réel
    assert_emails 1 do
      post contact_url, params: {
        name:    "Sami",
        email:   "sami@example.com",
        subject: "Hello",
        message: "Test message"
      }
    end
    assert_redirected_to root_path(anchor: "contact")
  end
end
