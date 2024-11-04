note
	description: "Root class for a company employee management application"
	authors: "Made by Matt Keefe, Matt Jolie, Paul O'Sullivan"
	date: "$Date: 2024/11/4 15:0:35 $"
	revision: "1.1.1"

class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			l_app: EV_APPLICATION
		do
			create l_app
			prepare
			l_app.launch
		end

	prepare
		local
			box: EV_VERTICAL_BOX -- https://www.eiffel.org/files/doc/static/24.05/libraries/vision2/ev_vertical_box_chart.html
			title_label: EV_LABEL -- https://www.eiffel.org/files/doc/static/24.05/libraries/vision2/ev_label_chart.html
			font: EV_FONT -- https://www.eiffel.org/files/doc/static/24.05/libraries/vision2/ev_font_chart.html
		do
			create_interface_objects
			create box.default_create
			create title_label.default_create
			title_label.set_text ("Welcome to the Company Management Program!")

			create font.default_create
			font.set_height (16)
			title_label.set_font (font)

			box.extend (title_label)
			box.extend (add_employee_button)
			box.extend (remove_employee_button)
			box.extend (display_company_tree_button)
			box.extend (print_employee_info_button)
			box.extend (update_employee_button)
			box.extend (search_employee_button)
			box.extend (quit_button)
			create first_window.default_create
			first_window.put (box)
			first_window.set_title ("Company Designer")
			first_window.set_size (400, 300)
			first_window.show
		end

	create_interface_objects
		do
			create add_employee_button.default_create
			add_employee_button.set_text ("Add Employee")
			add_employee_button.set_minimum_size (150, 30)
			create remove_employee_button.default_create
			remove_employee_button.set_text ("Remove Employee")
			remove_employee_button.set_minimum_size (150, 30)
			create display_company_tree_button.default_create
			display_company_tree_button.set_text ("Display Company Tree")
			display_company_tree_button.set_minimum_size (150, 30)
			create print_employee_info_button.default_create
			print_employee_info_button.set_text ("Print Employee Information")
			print_employee_info_button.set_minimum_size (150, 30)
			create update_employee_button.default_create
			update_employee_button.set_text ("Update Employee Information")
			update_employee_button.set_minimum_size (150, 30)
			create search_employee_button.default_create
			search_employee_button.set_text ("Search For Employee")
			search_employee_button.set_minimum_size (150, 30)
			create quit_button.default_create
			quit_button.set_text ("Quit Application")
			quit_button.set_minimum_size (150, 30)
			-- quit_button.select_actions.extend (agent quit_application) **need to look into select_actions more**
		end

feature -- Buttons

	add_employee_button: EV_BUTTON
	remove_employee_button: EV_BUTTON
	display_company_tree_button: EV_BUTTON
	print_employee_info_button: EV_BUTTON
	update_employee_button: EV_BUTTON
	search_employee_button: EV_BUTTON
	quit_button: EV_BUTTON

feature

	quit_application
		do
			if attached first_window as l_window then
				l_window.destroy
			end
		end

feature {NONE} -- Implementation

	first_window: EV_WINDOW

end
