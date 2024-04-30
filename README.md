# PetrykPyatochkin

App for facilitating personnel accounting at the enterprise. Information about positions and departments of enterprise, personal card for each worker, managing worker's vacations.

Built with: Rails 7.1.3, Ruby 3.2.2, postgres, Turbo, Stimulus, Bootstrap, Cloudinary, devise.

Test with: RSpec, factory_bot_rails and faker.

My native language is Ukrainian and this is a single language on app. But all interface text was made with I18n and easy to change with translating locale file.

Petryk Pyatochkin - is the main hero of the short Ukrainian animation film "How Petryk Pyatochkin counted elephants", which was realized in 1984 and became a cult for children in this period.

In this app, to receive access to company information, you need to enter your email address and password. There is no registration, the user or users is created through db:seeds.

The application stores information about all the departments in the company. Their abbreviation, name, who is the manager, and how many employees they have. More than 20 people cannot work in one department at the same time. The department is created without a manager, because he is also its employee, and employees are added to it later.  In order not to forget, in which departments there is no manager, this is highlighted in red text on the main page, the department page, and the personal page of the department. In the list of departments, in addition to the abbreviation and name, there is information about the manager and the number of employees. On the department's page, information about the names of its employees, their positions, and current active vacation is available. The manager role is defined when adding a new employee to a department or editing an existing one, but he will only become a manager if there is no manager in the department. To change the current manager, it is necessary to demote him to the level of an ordinary employee or remove him from the department. When deleting a department, all its employees are deleted from it.

The application stores information about all positions in the enterprise. Their names, corresponding salaries, and the number of vacation days per year. Positions cannot be deleted, as they are stored in the employee's history.

The application stores information about all employees at the enterprise, their passport data, a personal photo, as well as information related to work - when hired, in which position he works, history of positions with dates, salary, full salary (salary with a compound interest of 1.2% for a year of work), the department in which he works, when he will go on vacation, the history of previous vacations and how many unused vacation days are left this year. Therefore, before starting to add employees, it is advisable to create positions and departments. However, you can add them to each employee's personal card later.

From the employee's card, it is possible to edit not only personal data but also his position, department, and vacation. If an employee is fired, they become inactive for editing and are automatically fired from their last position and removed from the current department. When an employee is on vacation, it is not possible to edit his data and fire him. It is impossible to retroactively hire, fire, send an employee on vacation, or change his position. An employee can be sent on vacation only if he has an active position, and unused vacation days this year, and no more than 5 employees will be on vacation in his department during this period. Before the start of the vacation, it can be canceled, but the one that has already started can only be shortened to a maximum of the current day.

To facilitate the search for an employee, there is a special form in the main menu where you can enter his full last name or a few letters. The search will return all matches. On the start page, there is also information about employees who are celebrating a birthday or an anniversary of work at the company today.