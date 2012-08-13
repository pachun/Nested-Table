class MyViewController < NestedTable::Controller
  def master_menu_items
    5
  end

  def submenu_items_at(position)
    3
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
    cell.textLabel.text = "(#{master_position}) submenu @#{submenu_position}"
    cell
  end
end
