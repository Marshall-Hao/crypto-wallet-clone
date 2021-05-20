class WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :edit, :update]

  def index
    @wallets = policy_scope(Wallet)
  end

  def show
  end

  def new
    @wallet = Wallet.new
    authorize @wallet
  end

  def create
    @wallet = Wallet.new(wallet_params)
    @wallet.user = current_user
    authorize @wallet

    if @wallet.save
      redirect_to wallet_path(@wallet), notice: 'Wallet was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @wallet.update(wallet_params)

    # no need for app/views/restaurants/update.html.erb
    redirect_to wallet_path(@wallet), notice: 'Wallet was successfully edited.'
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
    authorize @wallet
  end

  def wallet_params
    params.require(:wallet).permit(:name)
  end

end
