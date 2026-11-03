class WheelhouseController < ApplicationController
  def home
    skip_authorization
  end

  def workshop
    skip_authorization
  end

  def about
    skip_authorization
  end
end