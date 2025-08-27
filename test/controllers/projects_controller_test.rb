# test/controllers/projects_controller_test.rb
require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get projects_url        # ou root_url
    assert_response :success
  end

  test "should get show" do
    p = projects(:site_mere)      # assure-toi d'avoir projects.yml avec un 'one' et un 'slug'
    get project_url(p.slug) # car param: :slug dans routes
    assert_response :success
  end
end
