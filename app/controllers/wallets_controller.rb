class WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :edit, :update] # find the @wallet for the show,edit and update

  def index
    @wallets = policy_scope(Wallet).order(created_at: :desc) # set the scope of wallets can be shown
  end

  def show
  end

  # ActiveRecord::RecordNotFound error rescue
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found
    flash[:alert] = "This wallet does not exist."
    redirect_to(wallets_path)
  end

  def new
    @wallet = Wallet.new
    authorize @wallet # pundit authorization
  end

  def create
    @wallet = Wallet.new(wallet_params) # get the input from new page
    @wallet.user = current_user # set the wallet.user_id is current_user
    authorize @wallet # pundit authorization

    if @wallet.save
      redirect_to wallet_path(@wallet), notice: 'Wallet was successfully created.'
    else
      render :new # return to the wallet new page
    end
  end

  def edit
  end

  def update
    @wallet.update(wallet_params) # get the input from edit page

    redirect_to wallet_path(@wallet), notice: 'Wallet was successfully edited.'
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id]) # find the current_wallet
    authorize @wallet # pundit authorization
  end

  def wallet_params
    params.require(:wallet).permit(:name) # the wallet can only allow name input
  end
end
