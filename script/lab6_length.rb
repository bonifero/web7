u = User.new(name: "a" * 51, email: "a" * 244 + "@example.com")
puts "valid: #{u.valid?}"
p u.errors.full_messages
