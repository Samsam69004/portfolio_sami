require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get new (one-page)" do
    get contact_page_url
    assert_response :success
  end

  test "should create contact and redirect to anchor" do
    ActionMailer::Base.deliveries.clear

    assert_emails 1 do
      post contact_url, params: {
        # IMPORTANT: scope:nil => pas de clé :contact
        name: "John",
        email: "john@example.com",
        subject: "Hello",
        message: "Coucou",
        website: "" # honeypot vide
      }
    end

    assert_redirected_to root_url(anchor: "contact")
  end
end
