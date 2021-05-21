class TransactionsController < ApplicationController
  before_action :set_wallet, only: [:new, :create] # find the @wallet for the new and create

  def new
    @transaction = Transaction.new
    authorize @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params) # get the input from new page
    @transaction.wallet = @wallet # set the transaction.wallet_id to be the current_wallet
    authorize @transaction # pundit authorization
    @activity = @transaction.activity # get the activity(deposit/withdraw/transfer) from transaction

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
    @wallet.update(balance: @wallet.balance + @transaction.amount) # deposit cash, balance increased
    transaction_save
  end

  def transfer_cash
    if @transaction.amount <= @wallet.balance # check if the transaction amount less than the balance
      @wallet.update(balance: @wallet.balance - @transaction.amount) # transfer cash out, balance decreased
      receiver_transaction_create # on the receiver side, it will generate a receive transaction
      transaction_save
    else
      insufficient_cash_alert
    end
  end

  def withdraw_cash
    if @transaction.amount <= @wallet.balance # check if the transaction amount less than the balance
      @wallet.update(balance: @wallet.balance - @transaction.amount) # withdraw cash out, balance decreased
      transaction_save
    else
      insufficient_cash_alert
    end
  end

  def receiver_transaction_create
    @receiver_wallet = User.find_by(email: @transaction.receiver_email).wallets.first #find the receiver wallet
    @receiver_wallet.update(balance: @receiver_wallet.balance + @transaction.amount) # receive money, balance increased
    @sender_email = @wallet.user.email # find the sender email for the transaction create
    # create the receive activity transaction with the necessary infomation
    Transaction.create(activity: "receive", amount: @transaction.amount, sender_email: @sender_email, wallet: @receiver_wallet)
  end

  def transaction_save
    if @transaction.save
      redirect_to wallet_path(@wallet), notice: 'Transaction was successfully created.'
    else
      render :new # return to the transaction new page
    end
  end

  def insufficient_cash_alert
    flash.now[:alert] = "Transaction cannot be done due to insufficient cash."
    render :new # return to the transaction new page
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id]) # find the current_wallet
    authorize @wallet # pundit authorization
  end

  # the transaction can only allown activity,amount,receiver_email input
  def transaction_params
    params.require(:transaction).permit(:activity, :amount, :receiver_email)
  end
end
