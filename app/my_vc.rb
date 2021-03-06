class MyViewController < NestedTable::Controller
  def master_menu_items
    5
  end

  def submenu_items_at(position)
    if position == 0
      1
    elsif position == 1
      3
    else
      2
    end
  end

  def master_item_height
    50
  end

  def submenu_item_height
    35
  end

  def get_master(cell, at:position)
    cell.textLabel.text = "master @#{position}"
    cell
  end

  def get_submenu(cell, at:master_position, and:submenu_position)
    cell.textLabel.text = "submenu @#{submenu_position}"
    cell
  end

  def touched_item(master_item_position, submenu_item_position)
    puts "touched item @ (#{master_item_position}, #{submenu_item_position})"
  end
end
