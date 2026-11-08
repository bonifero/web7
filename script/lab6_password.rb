u = User.new(name: "Example User", email: "user@example.com")
puts "without password valid: #{u.valid?}"
p u.errors.full_messages
u.password = u.password_confirmation = "abcde"
puts "short password valid: #{u.valid?}"
p u.errors.full_messages
