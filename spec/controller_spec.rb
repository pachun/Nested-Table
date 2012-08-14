describe 'A Nested Table Controller' do
  before do
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

    @nested_table = MyViewController.new
    @master_menu = @nested_table.master_menu
    @submenus = @nested_table.submenus
  end

  it 'should set up its member variables' do
    @nested_table.master_menu.should == @nested_table.tableView
    @nested_table.selected.nil?.should == true
    @nested_table.submenus.class.should == Array
  end

  it 'should supply every table view with exactly 1 section (no code for this: default)' do
    @nested_table.numberOfSectionsInTableView(UITableView.new).should == 1
  end

  it 'should forward \'height for row at index path\' to \'item_height\'' do
    index_path = NSIndexPath.indexPathForRow(0, inSection:0)
    @nested_table.tableView(@master_menu, heightForRowAtIndexPath:index_path).should == @nested_table.master_item_height
    @nested_table.tableView(nil, heightForRowAtIndexPath:index_path).should == @nested_table.submenu_item_height
  end

  it 'should have menu indentation presets' do
    @nested_table.tableView(@master_menu, indentationLevelForRowAtIndexPath:nil).should == 0
    @nested_table.tableView(nil, indentationLevelForRowAtIndexPath:nil).should == 3
  end

  it 'should forward \'rows in section\' to \'master_menu_items\' for the master menu' do
    @nested_table.tableView(@master_menu, numberOfRowsInSection:0).should == @nested_table.master_menu_items
  end

  it 'should initialize submenus when a count of the master menu items are queried' do
    master_items = @nested_table.tableView(@master_menu, numberOfRowsInSection:0)
    master_items.should == @submenus.count
    master_items.times do |submenu_position|
      @submenus[submenu_position].class.should == UITableView
    end
  end

  it 'should forward \'rows in section\' to \'submenu_items_at(position)\' for the submenus' do
    @nested_table.tableView(@master_menu, numberOfRowsInSection:0) # to instantiate the submenus
    @submenus.each do |submenu, position|
      @nested_table.tableView(submenu, numberOfRowsInSection:0).should == @nested_table.submenu_items_at(position)
    end
  end

  # it 'should use get_master:at: and get_submenu:at:and: when fetching cells' do
  #   @nested_table.tableView(@master_menu, numberOfRowsInSection:0) # to instantiate the submenus
  #   @nested_table.master_menu_items.times do |master_position|
  #     index_path = NSIndexPath.indexPathForRow(master_position, inSection:0)
  #     cell = @nested_table.tableView(@master_menu, cellForRowAtIndexPath:index_path)
  #     cell.textLabel.text.should == "master @#{master_position}"

  #     @nested_table.submenu_items_at(master_position).times do |submenu_position|
  #       index_path = NSIndexPath.indexPathForRow(submenu_position, inSection:0)
  #       cell = @nested_table.tableView(@submenus[submenu_position], cellForRowAtIndexPath:index_path)
  #       cell.textLabel.text.should == "(#{master_position}) submenu @#{submenu_position}"
  #     end
  #   end
  # end
end
