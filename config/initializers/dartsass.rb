# Let Dart Sass find the Bootstrap 3 stylesheets shipped inside the bootstrap-sass gem,
# so that `@import "bootstrap";` works in app/assets/stylesheets/*.scss.
bootstrap_path = File.join(Gem.loaded_specs["bootstrap-sass"].full_gem_path, "assets", "stylesheets")
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_path}"
# Bootstrap 3 uses old Sass syntax (@import, "/" division); silence those deprecation warnings.
Rails.application.config.dartsass.build_options << "--quiet-deps"
Rails.application.config.dartsass.build_options << "--silence-deprecation=import"
