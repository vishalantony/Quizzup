require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
  	get root_url
  	assert_template 'static_pages/home'
    puts "Printing root_url : #{root_url}"
  	assert_select "a[href=?]", root_url, count: 2

  	assert_select "a[href=?]", help_url
  	assert_select "a[href=?]", about_url
  	assert_select "a[href=?]", contacto_url

  end
end
