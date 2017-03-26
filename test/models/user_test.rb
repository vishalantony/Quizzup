require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: 'Example User', email: 'example@user.com', 
  						password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
  	assert @user.valid?
  end

  test 'name should be present' do
  	@user.name = ''
  	assert_not @user.valid?
  end

  test 'email should be present' do
  	@user.email = ''
  	assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |emailID|
  		@user.email = emailID
  		assert @user.valid?, "#{emailID.inspect} should be valid"
  	end
  end

  test 'email addresses should be correct' do
  	invalid_email_ids = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
  	invalid_email_ids.each do |emailID|
  		@user.email = emailID
  		assert_not @user.valid?, "#{emailID.inspect } should be invalid"
  	end
  end

  test 'email addresses should be unique' do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test 'email address should be saved in lower case' do
  	mixed_case_email = 'fooobaR@ExAmpLE.cOM'
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should not be blank' do
  	@user.password = @user.password_confirmation = ' '*6
  	assert_not @user.valid?
  end

  test 'password should be minimum 6 chars' do
  	@user.password = @user.password_confirmation = 'a'*5
  	assert_not @user.valid?
  end



end
