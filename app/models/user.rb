module Tribute
  module Models
    class User
      include Mongoid::Document
      include Mongoid::Timestamps

      field :provider, type: String
      field :uid, type: String
      field :token, type: String

      index({ provider: 1, uid: 1 }, { unique: true })
      index({ token: 1 })

      validates_presence_of :uid, :provider
      validates_uniqueness_of :uid, scope: :provider

    end
  end
end
