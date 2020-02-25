class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :repaid_loan, :approve, :repaid_lender]
  before_action :set_loan, only: [:new, :create, :edit, :update]
  skip_before_action :authenticate_user!, only: %i(index)
  #to do: add actions for sorting

  def index
    @contracts = Contract.all
  end

  def show
    authorize @contract
  end

  def new
    @contract = Contract.new
    authorize @contract
  end

  def create
    @contract = Contract.new(contract_params)
    authorize @contract
    @contract.loan = @loan
    @contract.user = current_user
    if @contract.save
      redirect_to loan_contract_path(id: @contract.id)
    else
      render :new
    end
  end

  def edit
    authorize @contract
  end

  def update
    authorize @contract
    if @contract.update(contract_params)
      redirect_to loan_contract_path(id: @contract.id)
    else
      render :edit
    end
  end

  def repaid_loan
    authorize @contract
    @contract.repaid_loan!
    redirect_to loan_contracts_path
  end

  def approve
    authorize @contract
    @contract.approve!
    redirect_to loan_contracts_path
  end

  def repaid_lender
    authorize @contract
    @contract.repaid_lender!
    redirect_to loan_contracts_path
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