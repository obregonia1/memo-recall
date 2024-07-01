# frozen_string_literal: true

class CategoryMemoriesController < ApplicationController
  before_action :set_category

  def index
    @q = @category.memories.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.blank?

    @memories = @q.result.page(params[:page]).per(10)
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end
end
