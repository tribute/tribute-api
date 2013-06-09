module Tribute
  module Models
    class User
      include Mongoid::Document
      include Mongoid::Timestamps

      field :provider, type: String
      field :uid, type: String

      index({ provider: 1, uid: 1 }, { unique: true })

      validates_presence_of :uid, :provider
      validates_uniqueness_of :uid, scope: :provider
    end
  end
end
