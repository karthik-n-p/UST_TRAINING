from datetime import datetime

class Expense:
    """
    Represents an expense record.

    Attributes:
        expense_id (int): Unique identifier for the expense.
        date (str): Date when the expense was incurred.
        category (str): Category of the expense (e.g., Food, Travel).
        description (str): Description of the expense.
        amount (float): Amount spent on the expense.
    """

    def __init__(self, expense_id, date, category, description, amount):
        """
        Initializes an Expense instance.

        Args:
            expense_id (int): Unique identifier for the expense.
            date (str): Date when the expense was incurred.
            category (str): Category of the expense.
            description (str): Description of the expense.
            amount (float): Amount spent on the expense.
        """
        self.expense_id = expense_id
        self.date = date
        self.category = category
        self.description = description
        self.amount = amount

    def __str__(self):
        """
        Returns a string representation of the expense.

        Returns:
            str: Detailed information about the expense.
        """
        return (f'Expense ID: {self.expense_id}\n'
                f'Date: {self.date}\n'
                f'Category: {self.category}\n'
                f'Description: {self.description}\n'
                f'Amount: ${self.amount:.2f}')


class Calc:
    """
    Manages and calculates expenses.

    Attributes:
        expense_storage (list): List of Expense objects.
    """

    def __init__(self):
        """
        Initializes the Calc instance with an empty expense list.
        """
        self.expense_storage = list()

    def add_expenses(self, expense):
        """
        Adds a new expense to the storage.

        Args:
            expense (Expense): The Expense object to be added.
        """
        self.expense_storage.append(expense)
        print("Expense added successfully.")

    def update_expense(self, expense_id, new_expense):
        """
        Updates an existing expense based on its ID.

        Args:
            expense_id (int): The ID of the expense to be updated.
            new_expense (Expense): The updated Expense object.
        """
        for i in range(len(self.expense_storage)):
            if self.expense_storage[i].expense_id == expense_id:
                self.expense_storage[i] = new_expense
                print("Expense updated successfully.")
                return
        print("No item found with the given expense ID.")

    def delete_expense(self, expense_id):
        """
        Deletes an expense from the storage based on its ID.

        Args:
            expense_id (int): The ID of the expense to be deleted.
        """
        for i in range(len(self.expense_storage)):
            if self.expense_storage[i].expense_id == expense_id:
                self.expense_storage.pop(i)
                print("Expense deleted successfully!")
                return
        print("No item found with the given expense ID.")

    def display_expense(self):
        """
        Displays all expenses currently in the storage.
        """
        if self.expense_storage:
            print("Current Expenses:")
            for expense in self.expense_storage:
                print(expense)
        else:
            print("No expenses found.")

    def categorize_expenses(self):
        """
        Categorizes expenses and sums amounts by category.

        Returns:
            dict: A dictionary where keys are categories and values are total amounts.
        """
        category_dictionary = dict()
        for expense in self.expense_storage:
            if expense.category in category_dictionary:
                category_dictionary[expense.category] += expense.amount
            else:
                category_dictionary[expense.category] = expense.amount
        return category_dictionary

    def summarize_expense(self):
        """
        Calculates the total amount of all expenses.

        Returns:
            float: Total amount of all expenses.
        """
        return sum(expense.amount for expense in self.expense_storage)

    def generate_summary_report(self):
        """
        Generates a summary report of all expenses, categorized and total.
        """
        print("\nExpense Summary Report:")
        categorized_expenses = self.categorize_expenses()
        for category, total in categorized_expenses.items():
            print(f"Category: {category} | Total Expenses: ${total:.2f}")

        total_expense = self.summarize_expense()
        print(f"\nTotal Expense: ${total_expense:.2f}")


class Authentication:
    """
    Handles user authentication.

    Attributes:
        user_dict (dict): A dictionary with usernames as keys and passwords as values.
    """
    user_dict = {"user": "user", "user1": "user1"}

    def authenticate_user(self, username, password):
        """
        Authenticates a user based on the provided username and password.

        Args:
            username (str): The username of the user.
            password (str): The password of the user.

        Returns:
            bool: True if authentication is successful, False otherwise.
        """
        if username in self.user_dict:
            return self.user_dict[username] == password
        return False


def cli():
    """
    Command-line interface for managing expenses.
    Allows users to add, update, delete, display, and generate reports for expenses.
    """
    calc = Calc()

    while True:
        choice = input("\nSelect an option:\n"
                       "1. Add item\n"
                       "2. Update item\n"
                       "3. Delete item\n"
                       "4. Display expenses\n"
                       "5. Generate summary report\n"
                       "6. Exit\n"
                       "Enter your choice: ")
        if choice == '1':
            print("\nEnter the details of the expense:")
            try:
                expense_id = int(input("Enter unique ID for expense: "))
                date = input("Enter the date (YYYY-MM-DD): ")
                datetime.strptime(date, '%Y-%m-%d')  # Validate date format
                category = input("Enter the category: ")
                description = input("Enter the description: ")
                amount = float(input("Enter the amount: "))

                expense = Expense(expense_id, date, category, description, amount)
                calc.add_expenses(expense)
            except ValueError as e:
                print(f"Invalid input: {e}. Please enter valid data.")

        elif choice == '2':
            print("\nEnter the details of the updated expense:")
            try:
                expense_id = int(input("Enter unique ID of the expense to be updated: "))
                new_expense_id = int(input("Enter the new unique ID for the expense: "))
                date = input("Enter the date (YYYY-MM-DD): ")
                datetime.strptime(date, '%Y-%m-%d')  # Validate date format
                category = input("Enter the category: ")
                description = input("Enter the description: ")
                amount = float(input("Enter the amount: "))

                new_expense = Expense(new_expense_id, date, category, description, amount)
                calc.update_expense(expense_id, new_expense)
            except ValueError as e:
                print(f"Invalid input: {e}. Please enter valid data.")

        elif choice == '3':
            try:
                expense_id = int(input("Enter the expense ID to delete: "))
                calc.delete_expense(expense_id)
            except ValueError:
                print("Invalid input. Please enter a valid integer ID.")

        elif choice == '4':
            calc.display_expense()

        elif choice == '5':
            calc.generate_summary_report()

        elif choice == '6':
            print("\nThank you for using our service!")
            break

        else:
            print("\nInvalid choice. Please select a valid option.")

def main():
    """
    Main function for user authentication and initiating the CLI.
    Prompts user for credentials and starts the CLI if authenticated.
    """
    print("\nWelcome to Expense Tracker")

    print("\nUser Authentication")
    username = input("Enter username: ")
    password = input("Enter password: ")
    auth = Authentication()
    if auth.authenticate_user(username, password):
        print("Login Successful")
        cli()
    else:
        print("\nWrong credentials. Please try again.")

if __name__ == "__main__":
    main()
