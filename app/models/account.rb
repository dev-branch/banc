class Account < ApplicationRecord
    has_many :transactions
    validates :name, uniqueness: true
    validates :name, :category, presence: true
    after_save :check_suspension

    def deposit(amount)
        check_amount(amount)

        ActiveRecord::Base.transaction do
            Transaction.create!(amount: amount, category: 'Deposit', account: self)
            self.update!(balance: self.balance + amount)
        end
    end

    def withdraw(amount)
        if self.is_suspended
            self.errors.add(:is_suspended, 'Cannot withdraw funds from a suspended account')
            return
        end

        check_amount(amount)

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

    def clear_suspension
        if self.balance < 100 || !self.is_suspended
            self.errors.add(:is_suspended, 'Not enough money in account or not suspended')
            return
        end

        ActiveRecord::Base.transaction do
            Transaction.create!(amount: 100, category: 'Fee', account: self)
            self.update!(is_suspended: false, balance: self.balance - 100)
        end
    end

    private
    
    def check_amount(amount)
        raise ArgumentError, 'amount is not numeric' if !amount.is_a? Numeric
        raise ArgumentError, 'amount is not positive' if amount <= 0
    end
    
    def check_suspension
        if self.flags > 3
            self.update!(is_suspended: true, flags: 0)
        end
    end
end
