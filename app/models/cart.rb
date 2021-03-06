class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user

  def total
    amount = 0
    self.line_items.each do |line_item|
      item = Item.find(line_item.item_id)
      amount += (item.price * line_item.quantity)
    end
    amount
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if items.include?(line_item.try(:item))
      line_item.quantity += 1
      line_item.save
    else
      line_item = self.line_items.build(item_id: item_id)
    end
    line_item
  end

  def checkout
    update(status: 'submitted')
    line_items.each do |i|
      item = Item.find(i.item_id)
      item.update(inventory: item.inventory - i.quantity)
    end
  end
end
