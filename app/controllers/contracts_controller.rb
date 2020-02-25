class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update]
  before_action :set_loan, only: [:new, :create, :edit, :update]
  #to do: add actions for sorting
  def index
    @contracts = Contract.all
  end

  def show
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.loan = @loan
    @contract.user = current_user
    if @contract.save
      redirect_to loan_contract_path(id: @contract.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contract.update(contract_params)
      redirect_to loan_contract_path(id: @contract.id)
    else
      render :edit
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:loan_id])
  end

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(:description, :user_id, :loan_id)
  end
end
