class User < ApplicationRecord
    has_secure_password # adds methods to set and authenticate against a BCrypt PW
    validates :username, uniqueness: { case_sensitive: false } #username must be unique regardless of capitalization
end
