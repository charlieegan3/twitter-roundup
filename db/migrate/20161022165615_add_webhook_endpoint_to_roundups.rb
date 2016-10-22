class AddWebhookEndpointToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :webhook_endpoint, :string
  end
end
