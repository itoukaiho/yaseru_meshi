# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def self.guest
      user = find_or_initialize_by(email: 'guest@example.com')
      user.password ||= SecureRandom.urlsafe_base64(8)
      user.name ||= 'ゲストユーザー'
      user.save! if user.new_record? || user.changed?
      user
    end
  end
end
