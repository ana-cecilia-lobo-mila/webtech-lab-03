require "test_helper"

class WelcomeMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = User.take
    mail = WelcomeMailer.welcome(user)

    assert_equal "Welcome to Wheelhouse", mail.subject
    assert_equal [ user.email_address ], mail.to
    assert_equal [ "no-reply@wheelhouse.local" ], mail.from

    assert_match "Welcome to Wheelhouse", mail.body.encoded
    assert_match user.email_address, mail.body.encoded
    assert_match "Sign in to Wheelhouse", mail.body.encoded

    assert_equal 2, mail.parts.size
    assert mail.text_part
    assert mail.html_part
  end
end