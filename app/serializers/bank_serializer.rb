# frozen_string_literal: true

class BankSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :namehira
end
