class Account < ApplicationRecord
    has_many :transactions
    validates :name, uniqueness: true
    validates :name, :category, presence: true
    after_save :check_suspension

    def deposit(amount)
        return if check_amount(amount).any?

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

        return if check_amount(amount).any?

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
        self.errors.add(:amount, 'not a number') if !amount.is_a? Numeric
        self.errors.add(:amount, 'is not greater than 0') if amount <= 0
        self.errors
    end

    def check_suspension
        if self.flags > 3
            self.update!(is_suspended: true, flags: 0)
        end
    end
end
