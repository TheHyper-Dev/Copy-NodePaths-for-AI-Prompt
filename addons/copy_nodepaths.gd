# copy_nodepaths.gd
# This is the main plugin file that extends EditorPlugin

@tool
extends EditorPlugin

var context_menu_plugin

func _enter_tree():
	# Create and register the context menu plugin for the scene tree
	context_menu_plugin = SceneTreeContextMenu.new()
	add_context_menu_plugin(EditorContextMenuPlugin.ContextMenuSlot.CONTEXT_SLOT_SCENE_TREE, context_menu_plugin)

func _exit_tree():
	# Clean up when the plugin is disabled
	if context_menu_plugin:
		remove_context_menu_plugin(context_menu_plugin)
		context_menu_plugin = null

# SceneTreeContextMenu class that handles the context menu
class SceneTreeContextMenu:
	extends EditorContextMenuPlugin

	func _init():
		print("SceneTreeContextMenu plugin initialized")

	func _popup_menu(paths: PackedStringArray) -> void:
		# Only show our custom menu items when right-clicking on scene tree nodes
		if not paths.is_empty():
			# Get the NodePath icon from the editor theme
			var nodepath_icon = EditorInterface.get_editor_theme().get_icon("NodePath", "EditorIcons")

			# Add the context menu items with the icon
			add_context_menu_item("Copy the NodePaths of Node and its whole Family Tree", _on_copy_node_tree_all, nodepath_icon)
			add_context_menu_item("Copy the NodePaths of Node and its Children (1st gen)", _on_copy_node_tree_exclude_internal, nodepath_icon)

	func _on_copy_node_tree_all(paths: PackedStringArray) -> void:
		if paths.is_empty():
			return

		var selected_nodes = EditorInterface.get_selection().get_selected_nodes()

		if selected_nodes.is_empty():
			push_error("No node selected")
			return

		var root_node = selected_nodes[0]

		# Generate the tree structure including all descendants
		var tree_text = _generate_full_tree(root_node, "", true)

		# Copy to clipboard
		DisplayServer.clipboard_set(tree_text.strip_edges())

		print("Copied node and entire family tree to clipboard")

	func _on_copy_node_tree_exclude_internal(paths: PackedStringArray) -> void:
		if paths.is_empty():
			return

		var selected_nodes = EditorInterface.get_selection().get_selected_nodes()

		if selected_nodes.is_empty():
			push_error("No node selected")
			return

		var root_node = selected_nodes[0]

		# Generate the tree structure with only direct children, excluding internal ones
		var tree_text = _generate_direct_children_tree(root_node, true)

		# Copy to clipboard
		DisplayServer.clipboard_set(tree_text.strip_edges())

		print("Copied node and direct children (excluding internal) to clipboard")

	# Generate a full tree structure with all descendants
	func _generate_full_tree(node: Node, prefix: String = "", is_last: bool = true) -> String:
		var result = ""
		
		# Add current node with proper prefix
		if prefix == "":
			result += node.name + "\n"
		#else:
		elif prefix != "":
			result += prefix + node.name + "\n"
		
		# Get all children
		var children = node.get_children()
		var child_count = children.size()
		
		# Process each child
		for i in range(child_count):
			var child = children[i]
			var is_last_child = (i == child_count - 1)
			
			# Build the prefix for the child nodes
			var child_prefix = ""
			if prefix != "":
				# Replace the connector characters to continue the vertical lines
				var continuation_prefix = prefix.replace("├─ ", "│  ").replace("└─ ", "   ")
				child_prefix = continuation_prefix
			
			# Add the appropriate tree connector for this child
			var connector = "└─ " if is_last_child else "├─ "
			var new_prefix = child_prefix + connector
			
			result += _generate_full_tree(child, new_prefix, is_last_child)
		
		return result

	# Generate a tree structure with only direct children (not grandchildren)
	# exclude_internal: if true, internal children will be skipped
	func _generate_direct_children_tree(node: Node, exclude_internal: bool) -> String:
		var result = ""

		# Add current node
		result += node.name + "\n"

		# Get direct children, filtering out internal ones if requested
		var children = []
		for child in node.get_children():
			if exclude_internal and child.name.begins_with("@"):
				continue
			children.append(child)

		var child_count = children.size()

		# Add direct children with tree structure
		for i in range(child_count):
			var child = children[i]
			var is_last = (i == child_count - 1)

			if is_last:
				result += "└─ " + child.name + "\n"
			else:
				result += "├─ " + child.name + "\n"

		return result
