# frozen_string_literal: true

def basic_environment
  ENV['G_MAIL'] = 'jakovlev.fedor.me@gmail.com'
  ENV['G_PASS'] = File.open('gmail_pass.txt', 'r').gets.strip

  ENV['Y_MAIL'] = 'jakovlev.fedor.me@yandex.ru'
  ENV['Y_PASS'] = File.open('mail_pass.txt', 'r').gets.strip
end

namespace :app do
  desc 'Set up the environment locally'
  task :environment do
    warn 'Entering :app:environment'
    basic_environment
  end

  desc 'Run the app locally'
  task run_local: 'app:environment' do
    exec 'bundle exec rerun ruby app.rb'
  end
end

# run rake app:run_local
