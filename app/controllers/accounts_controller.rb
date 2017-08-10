class AccountsController < ApplicationController
    def index
        @accounts = Account.order(id: :desc)
    end

    def new
        @account = Account.new
    end

    def create
        @account = Account.new(params[:account].permit(:name, :category))
        
        if @account.save
            redirect_to root_url
        else
            render 'new'
        end
    end

    def transactions
        @account = Account.find(params[:id])
    end

    def atm
        @account = Account.find(params[:id])
    end

    def deposit
        @account = Account.find(params[:id])
        amount = params[:amount].to_f
        @account.deposit(amount)

        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end
    end

    def withdraw
        @account = Account.find(params[:id])
        amount = params[:amount].to_f
        @account.withdraw(amount)

        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end
    end

    def clear
        @account = Account.find(params[:id])
        @account.clear_suspension

        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end
    end
end
