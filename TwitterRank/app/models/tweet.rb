class Tweet < ActiveRecord::Base
	validates :identifier, :data, presence: true
	validates :identifier, uniqueness: true
end