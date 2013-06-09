require 'spec_helper'

describe Tribute::Models::User do
  its(:id) { should be_a Moped::BSON::ObjectId }
  it { should validate_presence_of(:uid) }
  it { should validate_uniqueness_of(:uid) }
end