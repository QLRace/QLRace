namespace :db do
  task purge_old_tokens: :environment do
    ApiUser.find_each do |user|
      Tiddle.purge_old_tokens(user)
    end
  end
end
