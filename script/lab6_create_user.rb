user = User.find_or_initialize_by(email: "michael@example.com")
user.assign_attributes(name: "Michael Hartl", password: "foobar", password_confirmation: "foobar")
user.save!
puts "created id=#{user.id}; email=#{user.email}"
puts "digest uses bcrypt: #{user.password_digest.start_with?("$2a$", "$2b$")}"
