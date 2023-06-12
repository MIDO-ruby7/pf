class ItemsController < ApplicationController
  before_action :set_item, only: %i[edit update destroy]
  def index
    @items = Item.all.includes(:photos).order(created_at: :desc)
  end

  #画像のアップロード機能
  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.find_or_initialize_by(name: item_params[:name])

    if @item.new_record?
      @item.save
      @item.photos.create(image: item_params[:image])
      redirect_to items_path, notice: '新種を登録しました'
    else
      @item.photos.create(image: item_params[:image])
      redirect_to root_path, notice: '画像を登録しました'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit; end

  def update
    @item.update(item_params)
    redirect_to items_path, notice: '図鑑を更新しました'
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: '図鑑を削除しました', status: :see_other
  end

  private

  def item_params
    params.require(:item).permit(:name, :image, :image_cache, :size)
  end

  def set_item
    @item = current_user.items.find(params[:id])
  end
end
