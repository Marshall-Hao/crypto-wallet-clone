class TransactionsController < ApplicationController
  before_action :set_wallet, only: [:new, :create]

  def new
    @transaction = Transaction.new
    authorize @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.wallet = @wallet
    authorize @transaction
    @activity = @transaction.activity

    case @activity
    when 'deposit'
      deposit_cash
    when 'transfer'
      transfer_cash
    else
      withdraw_cash
    end
  end

  def deposit_cash
    @wallet.update(balance: @wallet.balance + @transaction.amount)
    transaction_save
  end

  def transfer_cash
    if @transaction.amount <= @wallet.balance
      @wallet.update(balance: @wallet.balance - @transaction.amount)
      receiver_transaction_create
      transaction_save
    else
      insufficient_cash_alert
    end
  end

  def withdraw_cash
    if @transaction.amount <= @wallet.balance
      @wallet.update(balance: @wallet.balance - @transaction.amount)
      transaction_save
    else
      insufficient_cash_alert
    end
  end

  def receiver_transaction_create
    @receiver_wallet = User.find_by(email: @transaction.receiver_email).wallets.first
    @receiver_wallet.update(balance: @receiver_wallet.balance + @transaction.amount)
    @sender_email = @wallet.user.email
    Transaction.create(activity: "receive", amount: @transaction.amount, sender_email: @sender_email, wallet: @receiver_wallet)
  end

  def transaction_save
    if @transaction.save
      redirect_to wallet_path(@wallet), notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  def insufficient_cash_alert
    flash.now[:alert] = "Transaction cannot be done due to insufficient cash."
    render :new
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
    authorize @wallet
  end

  def transaction_params
    params.require(:transaction).permit(:activity, :amount, :receiver_email)
  end
end
