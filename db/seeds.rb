# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
require 'zengin_code'

ZenginCode::Bank.all.each do |original_code, original_bank|
  puts "== #{original_code}:#{original_bank.name}"
  bank = Bank.find_or_initialize_by(code: original_code)
  bank.name = original_bank.name
  bank.namekana = original_bank.kana
  bank.namehira = original_bank.hira
  bank.roma = original_bank.roma
  bank.touch unless bank.new_record?
  bank.save!

  original_bank.branches.each do |original_branch_code, original_branch|
    puts "-- #{bank.code}:#{bank.name} #{original_branch_code}:#{original_branch.name}"
    branch = bank.branches.find_or_initialize_by(code: original_branch_code)
    branch.name = original_branch.name
    branch.namekana = original_branch.kana
    branch.namehira = original_branch.hira
    branch.roma = original_branch.roma
    branch.touch unless branch.new_record?
    branch.save!
  end
end

puts "Bank: #{Bank.count}, Branch: #{Branch.count}"
