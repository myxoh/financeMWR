class RemoveColumnStringFromWatchlist < ActiveRecord::Migration[5.0]
  def change
    remove_column :watchlists, :string
  end
end
