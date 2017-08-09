class Account < ApplicationRecord
    has_many :transactions

    def deposit(amount)
        check_amount

        ActiveRecord::Base.transaction do
            Transaction.create!(amount: amount, category: 'Deposit', account: self)
            self.update!(balance: self.balance + amount)
        end
    end

    def withdraw(amount)
        check_amount

        if amount <= self.balance
            ActiveRecord::Base.transaction do
                Transaction.create!(amount: amount, category: 'Withdraw', account: self)
                self.update!(balance: self.balance - amount)
            end
        else
            ActiveRecord::Base.transaction do
                Transaction.create!(amount: 50, category: 'Fee', account: self)
                self.update!(balance: self.balance - 50, flags: self.flags + 1)
            end
        end
    end

    private
    
    def check_amount(amount)
        raise ArgumentError, 'amount is not numeric' if !amount.is_a? Numeric
        raise ArgumentError, 'amount is not positive' if amount <= 0
    end
end
