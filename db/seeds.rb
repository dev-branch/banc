# Transaction.destroy_all
# Account.destroy_all
 
# 3.times do |i|
#     a = Account.create!(
#         category: ['Checking', 'Savings'].sample,
#         balance: (100..500).to_a.sample,
#         )
#     p "hello world"
#     p a
#     5.times do |j| 
#         Transaction.create!(
#         category: ['Deposit', 'Withdraw', 'Fee'].sample,
#         amount: (10..1000).to_a.sample,
#         account: a
#         )
#     end
# end
