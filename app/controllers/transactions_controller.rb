class TransactionsController < ApplicationController
  before_action :set_wallet, only: [:new, :create]

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.wallet = @wallet
    if @transaction.activity == 'deposit'
      @wallet.update(balance: @wallet.balance + @transaction.amount)
      if @transaction.save
        redirect_to wallet_path(@wallet), notice: 'Transaction was successfully created.'
      else
        render :new
      end
    else
      if @transaction.amount <= @wallet.balance
        @wallet.update(balance: @wallet.balance - @transaction.amount)
        if @transaction.save
          redirect_to wallet_path(@wallet), notice: 'Transaction was successfully created.'
        else
          render :new
        end
      else
        flash.now[:alert] = "Transaction cannot be done due to insufficient cash."
        render :new
      end
    end
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
  end

  def transaction_params
    params.require(:transaction).permit(:activity, :amount)
  end
end
