u = User.new
puts "valid: #{u.valid?}"
p u.errors.full_messages
puts "messages class: #{u.errors.messages.class}"
p u.errors.messages
puts "email errors: #{u.errors[:email].inspect}"
