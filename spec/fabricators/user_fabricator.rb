Fabricator(:user, from: Tribute::Models::User) do
  uid { Fabricate.sequence(:user_uid) { |i| i.to_s } }
  token { SecureRandom.hex(16) }
  provider "github"
end
