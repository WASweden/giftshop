class PersonsController < ApplicationController
  respond_to :json

  def create
    personal_number = params[:id]

    @person = Rails.cache.fetch(personal_number, expires_in: 30.days) do
      kommed_client.get_person(personal_number).body
    end

    render json: @person

  rescue Kommed::Error::ResourceNotFoundError
    render json: {}, status: :not_found
  end

  private

  def kommed_client
    @kommed_client ||= Kommed::Client.new
  end
end
