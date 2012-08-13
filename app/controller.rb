module NestedTable
  class Controller < UITableViewController
    attr_accessor :master_menu, :submenus

    def init
      initWithStyle(UITableViewStylePlain)
      @master_menu = tableView
      @submenus = []
      self
    end

    def tableView(table_view, didSelectRowAtIndexPath:index_path)
      # if table_view == @master_menu
    end

    def tableView(table_view, cellForRowAtIndexPath:index_path)
      if table_view == @master_menu
        cell = get_cell "master cell"
        master_position = index_path.row
        get_master(cell, at:master_position)
      else
        cell = get_cell "submenu cell"
        submenu_position = index_path.row
        master_position = -1
        @submenus.each_with_index do |submenu, position|
          if table_view == submenu
            master_position = position
          end
        end
        get_submenu(cell, at:master_position, and:submenu_position)
      end
    end

    def tableView(table_view, numberOfRowsInSection:section)
      if table_view == @master_menu
        items = master_menu_items

        # make all the submenu table views
        master_menu_items.times do |master_position|
          xpos = 0
          ypos = master_item_height
          width = CGRectGetWidth(@master_menu.frame)
          height = submenu_item_height * submenu_items_at(master_position)
          submenu_frame = [[xpos, ypos], [width, height]]
          @submenus << UITableView.alloc.initWithFrame(submenu_frame, style:UITableViewStylePlain)
          @submenus.last.delegate = self
          @submenus.last.dataSource = self
        end
      else

        # find the submenu's index
        @submenus.each do |submenu, position|
          items = submenu_items_at(position) if table_view == submenu
        end
      end

      items
    end

    def tableView(table_view, heightForRowAtIndexPath:index_path)
      if table_view == @master_menu
        master_item_height
      else
        submenu_item_height
      end
    end

    def tableView(table_view, indentationLevelForRowAtIndexPath:index_path)
      if table_view == @master_menu
        0
      else
        3
      end
    end

    private

    # cell creation

    def get_cell(identifier)
      cell = recycled_cell(identifier)
      cell = new_cell(identifier) if cell.nil?
      cell
    end

    def recycled_cell(identifier)
      tableView.dequeueReusableCellWithIdentifier(identifier)
    end

    def new_cell(identifier)
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
      if identifier == "master cell"
        cell.textLabel.text = 'hello'
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell.imageView.image = UIImage.imageNamed("toggle_master.png")
      else
        cell.textLabel.text = 'sub rowsies'
        cell.selectionStyle = UITableViewCellSelectionStyleGray
      end
      cell
    end
  end
end
