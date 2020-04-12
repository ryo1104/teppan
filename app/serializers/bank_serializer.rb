class BankSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :code, :name, :namehira
end