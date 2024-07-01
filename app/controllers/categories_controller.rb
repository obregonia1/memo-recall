# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy destroy_with_memories]

  def index
    @q = Category.ransack(params[:q])
    @q.sorts = 'id desc' if @q.sorts.blank?

    @categories = @q.result.page(params[:page])
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    if @category.save
      redirect_to categories_path, notice: t('notice.create.category')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: t('notice.update', model: Category.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: t('notice.destroy.category')
  end

  def destroy_with_memories
    @category.memories.destroy_all
    @category.destroy
    redirect_to memories_path, notice: t('notice.destroy.category_with_memories')
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
