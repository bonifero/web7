# Run at the section 6.1 commit, before adding validations.
User.transaction do
  user = User.new(name: "Michael Hartl", email: "michael@example.com")
  puts "6.1.2: #{[ user.class, User.superclass, ApplicationRecord.superclass ].inspect}"
  puts "new valid: #{user.valid?}; persisted: #{user.persisted?}"
  user.save!
  puts "6.1.3: #{[ user.name.class, user.email.class, user.created_at.class, user.updated_at.class ].inspect}"
  other = User.create!(name: "A Nother", email: "another@example.org")
  other.destroy!
  puts "destroyed: #{other.destroyed?}"
  begin
    User.find(other.id)
  rescue ActiveRecord::RecordNotFound => e
    puts "find deleted: #{e.class}"
  end
  puts "6.1.4: #{[ User.find(user.id).id, User.find_by(email: user.email).id, User.find_by(name: user.name).id, User.find_by_name(user.name).id, User.first.id ].inspect}"
  puts "all: #{User.all.class}; length: #{User.all.length}"
  user.name = "Updated Name"
  user.save!
  user.update!(email: "updated@example.com")
  user.email = "unsaved@example.com"
  puts "reload email: #{user.reload.email}"
  past = 1.year.ago
  user.created_at = past
  user.save!
  puts "6.1.5: #{user.name}; created_at restored: #{user.reload.created_at.to_i == past.to_i}"
  puts "6.2.1: new valid: #{User.new.valid?}; saved valid: #{user.valid?}"
  raise ActiveRecord::Rollback
end
