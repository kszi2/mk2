require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: "testuser", password: "password123", password_confirmation: "password123")
  end

  test "valid user should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = ""
    refute @user.valid?
    assert_includes @user.errors[:username], "can't be blank"
  end

  test "username should be unique" do
    duplicate_user = @user.dup
    @user.save!
    refute duplicate_user.valid?
    assert_includes duplicate_user.errors[:username], "has already been taken"
  end

  test "username length should be within range" do
    @user.username = "a"
    refute @user.valid?

    @user.username = "a" * 33
    refute @user.valid?
  end

  test "email should be unique" do
    @user.email = "test@example.com"
    @user.save!
    duplicate_user = @user.dup
    refute duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "email should be nil when blank" do
    @user.email = ""
    @user.valid?
    assert_nil @user.email
  end

  test "email should have a valid format" do
    invalid_emails = ["invalid", "user@", "@example.com", "user@example,com"]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      refute @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "password should be present on create" do
    @user.password = ""
    refute @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "password confirmation should match password" do
    @user.password_confirmation = "different"
    refute @user.valid?
    assert_includes @user.errors[:password_confirmation], "doesn't match Password"
  end

  test "admin? method should return true only for username 'admin'" do
    @user.username = "admin"
    assert @user.admin?

    @user.username = "not_admin"
    refute @user.admin?
  end
end
