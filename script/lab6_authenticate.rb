user = User.find_by!(email: "michael@example.com")
puts "found after restart: #{user.id} #{user.name}"
puts "wrong password: #{user.authenticate("not_the_right_password").inspect}"
puts "foobaz: #{user.authenticate("foobaz").inspect}"
puts "correct password returns user: #{user.authenticate("foobar") == user}"
puts "boolean: #{!!user.authenticate("foobar")}"
user.name = "Никита Сотников"
puts "save without password: #{user.save}"
p user.errors.full_messages
user.update_attribute(:name, "Никита Сотников")
puts "updated name: #{user.reload.name}"
