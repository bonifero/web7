#!/usr/bin/env bash
set -euo pipefail
bundle exec rails db:migrate
cp db/schema.rb tmp/schema-before-rollback.rb
bundle exec rails db:rollback
if grep -q 'create_table "users"' db/schema.rb; then exit 1; fi
printf 'Rollback removed users: PASS\n'
bundle exec rails db:migrate
diff tmp/schema-before-rollback.rb db/schema.rb
printf 'Schema restored exactly: PASS\n'
bundle exec rails runner 'p User.column_names; p [User.new.class, User.superclass, ApplicationRecord.superclass]'
