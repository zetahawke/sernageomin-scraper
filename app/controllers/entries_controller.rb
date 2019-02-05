class EntriesController < ApplicationController
  def Index
    result = Entry.all
    render json: { number: result.size, data: result.page(params[:page] || 1).per(params[:per_page] || 25) }, status: :ok
  end

  def init_scrap
    raise if params[:url].blank?
    if Entry.number_of_current_jobs > 0
      render json: { data: { status: 'There is some running process.' } }
    else
      Entry.scrap_more_results(params[:url], params[:region], params[:page])
      render json: { data: { status: 'Starting to scrap' } }, status: :ok
    end
  end

  def empty_records
    result = Entry.where(region: nil)
    render json: { number: result.size, data: result.page(params[:page] || 1).per(params[:per_page] || 25) }, status: :ok
  end

  def completed_records
    result = Entry.where.not(region: nil)
    render json: { number: result.size, data: result.page(params[:page] || 1).per(params[:per_page] || 25) }, status: :ok
  end
end
