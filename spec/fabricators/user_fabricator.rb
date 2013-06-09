Fabricator(:user, from: Tribute::Models::User) do
  uid { Fabricate.sequence(:user_uid) { |i| i.to_s } }
  provider "github"
end
