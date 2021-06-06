# frozen_string_literal: true

class Pageview < ApplicationRecord
  belongs_to  :user
  belongs_to  :pageviewable, polymorphic: true
  counter_culture :pageviewable
end
