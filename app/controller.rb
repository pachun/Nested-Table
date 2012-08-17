module NestedTable
  class Controller < UITableViewController
    attr_accessor :master_menu, :submenus, :selected

    def init
      initWithStyle(UITableViewStylePlain)
      @master_menu = tableView
      @selected = nil
      @submenus = []
      self
    end

    def tableView(table_view, didSelectRowAtIndexPath:index_path)
      cell = table_view.cellForRowAtIndexPath(index_path)
      if table_view == @master_menu
        last_selected = @selected
        @selected = index_path.row

        old_index_path = NSIndexPath.indexPathForRow(last_selected, inSection:0) unless last_selected.nil?
        old_cell = @master_menu.cellForRowAtIndexPath(old_index_path)

        label_frame = cell.textLabel.frame
        arrow_frame = cell.imageView.frame
        @master_menu.beginUpdates
        @master_menu.endUpdates
        cell.textLabel.frame = label_frame
        cell.imageView.frame = arrow_frame

        rotation_radians = 1.57
        unless @selected == last_selected # animated on a new row selection
          UIView.animateWithDuration(0.2, delay:0, options:0, animations:lambda do
            cell.imageView.transform = CGAffineTransformRotate(cell.imageView.transform, rotation_radians)
            unless last_selected.nil?
              @submenus[ last_selected ].hidden = true
              old_cell.imageView.transform = CGAffineTransformRotate(cell.imageView.transform, -rotation_radians)
            end
          end, completion:lambda do |finished_animating|
            @submenus[ @selected ].hidden = false
          end)

        end
      else
        master_index = @selected
        submenu_index = index_path.row
        touched_item(master_index, submenu_index)
      end
    end

    def show_submenu
    end

    def tableView(table_view, cellForRowAtIndexPath:index_path)
      if table_view == @master_menu
        cell = get_cell "master cell"
        master_position = index_path.row
        cell.frame = [ [CGRectGetMinX(cell.frame), CGRectGetMinY(cell.frame)], [CGRectGetWidth(cell.frame), master_item_height] ]
        cell.addSubview(@submenus[master_position])
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
          submenu_frame = [ [xpos, ypos], [width, height] ]
          @submenus << UITableView.alloc.initWithFrame(submenu_frame, style:UITableViewStylePlain)
          @submenus.last.separatorStyle = UITableViewCellSeparatorStyleNone
          @submenus.last.hidden = true
          @submenus.last.delegate = self
          @submenus.last.dataSource = self
        end
      else
        @submenus.each_with_index do |submenu, position|
          items = submenu_items_at(position) if table_view == submenu
        end
      end

      items
    end

    def tableView(table_view, heightForRowAtIndexPath:index_path)
      row = index_path.row
      if table_view == @master_menu
        if @selected == row
          master_item_height + submenu_item_height * submenu_items_at(row)
        else
          master_item_height
        end
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell.imageView.image = UIImage.imageNamed("toggle_master.png")
      else
        cell.selectionStyle = UITableViewCellSelectionStyleGray
      end
      cell
    end
  end
end
