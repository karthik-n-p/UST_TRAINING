import random

class Product:
    """
    Represents a product in the marketplace.

    Attributes:
        product_id (int): The unique identifier for the product.
        name (str): The name of the product.
        category (str): The category of the product.
        price (float): The price of the product.
    """

    def __init__(self, product_id, name, category, price):
        self.product_id = product_id
        self.name = name
        self.category = category
        self.price = price

    def __str__(self):
        """
        Returns a string representation of the product.
        """
        return f'Product ID: {self.product_id} \nName: {self.name} \nCategory: {self.category} \nPrice: {self.price}'


class UserFunctions:
    """
    Handles user operations such as adding items to the cart,
    deleting items from the cart, and displaying the cart.
    """

    def __init__(self):
        self.cart = list()

    def add_cart(self, product):
        """
        Adds a product to the user's cart.

        Args:
            product (dict): The product to add to the cart.
        """
        try:
            self.cart.append(product)
            print("Product added")
        except Exception as e:
            print(f"Error adding product to cart: {e}")

    def delete_cart(self, product_id):
        """
        Deletes a product from the user's cart based on the product ID.

        Args:
            product_id (int): The ID of the product to delete.
        """
        try:
            for i in range(len(self.cart)):
                if self.cart[i]['product_id'] == product_id:
                    self.cart.remove(self.cart[i])
                    print("Product deleted successfully!")
                    return
            print("No item found with the given product ID")
        except Exception as e:
            print(f"Error deleting product from cart: {e}")

    def display_cart(self):
        """
        Displays all products currently in the user's cart.
        """
        try:
            for i in range(len(self.cart)):
                print(f"Product {i}: \t {self.cart[i]}")
            if len(self.cart) == 0:
                print("No items found")
        except Exception as e:
            print(f"Error displaying cart: {e}")


class AdminFunctions:
    """
    Handles admin operations such as adding, updating,
    deleting, and displaying products in the catalog.
    """

    def __init__(self):
        self.item_storage = list()

    def add_item(self, product):
        """
        Adds a product to the admin's catalog.

        Args:
            product (Product): The product to add.
        """
        try:
            item = vars(product)
            self.item_storage.append(item)
            print("Product added")
        except Exception as e:
            print(f"Error adding product to catalog: {e}")

    def update_item(self, product_id, new_product):
        """
        Updates a product in the catalog based on the product ID.

        Args:
            product_id (int): The ID of the product to update.
            new_product (Product): The updated product object.
        """
        try:
            d = vars(new_product)
            for i in range(len(self.item_storage)):
                if self.item_storage[i]['product_id'] == product_id:
                    self.item_storage[i] = d
                    print("Product updated successfully")
                    return
            print("No item found with the given product ID")
        except Exception as e:
            print(f"Error updating product: {e}")

    def delete_item(self, product_id):
        """
        Deletes a product from the catalog based on the product ID.

        Args:
            product_id (int): The ID of the product to delete.
        """
        try:
            for i in range(len(self.item_storage)):
                if self.item_storage[i]['product_id'] == product_id:
                    self.item_storage.remove(self.item_storage[i])
                    print("Product deleted successfully!")
                    return
            print("No item found with the given product ID")
        except Exception as e:
            print(f"Error deleting product: {e}")

    def display_item(self):
        """
        Displays all products currently in the catalog.
        """
        try:
            for i in range(len(self.item_storage)):
                print(f"Product {i+1}: \t {self.item_storage[i]}")
            if len(self.item_storage) == 0:
                print("No items found")
        except Exception as e:
            print(f"Error displaying catalog: {e}")

    def return_catalog(self):
        """
        Returns the current catalog of products.

        Returns:
            list: A list of all products in the catalog.
        """
        return self.item_storage


class Authentication:
    """
    Handles user and admin authentication for login.
    """
    user_db = {"user": "user", "user1": "user1"}
    admin_db = {"admin": "admin"}

    def user_login(self, username, password):
        """
        Authenticates a user based on the provided username and password.

        Args:
            username (str): The username of the user.
            password (str): The password of the user.
        """
        if username in self.user_db:
            if self.user_db[username] == password:
                print(f"\nLogin Successful\nWelcome, {username}\n")
                usercli()
            else:
                print("\nWrong Password\n")
        else:
            print('\nWrong Username\n')

    def admin_login(self, username, password):
        """
        Authenticates an admin based on the provided username and password.

        Args:
            username (str): The username of the admin.
            password (str): The password of the admin.
        """
        if username in self.admin_db:
            if self.admin_db[username] == password:
                print(f"\nWelcome, Admin {username}\n")
                admincli()
            else:
                print("\nWrong Password\n")
        else:
            print('\nWrong Username\n')


def generate_session_id():
    """
    Generates a random session ID for the user or admin.

    Returns:
        int: A randomly generated session ID.
    """
    return random.randint(10000, 100000)


# Admin CLI Interface
f = AdminFunctions()

def admincli():
    """
    CLI for admin operations, allowing the admin to add, update,
    delete, and display products in the catalog.
    """
    session_id = generate_session_id()
    print(f"Admin session ID: {session_id}")

    while True:
        try:
            choice = input("Select a Choice:\n1. Add item\n2. Update item\n3. Delete item\n4. Display Catalog\n6. Log Out\n")
            if choice == '1':
                print("\nEnter the details of the product\n")
                product_id = int(input("Enter unique ID for the product: "))
                name = input("Enter the name of the product: ")
                category = input("Enter the category: ")
                price = int(input("Enter the price of the product: "))

                obj1 = Product(product_id, name, category, price)
                f.add_item(obj1)
            elif choice == '2':
                print("\nEnter the details of the updated product\n")
                product_id = int(input("Enter unique ID of the product to be updated: "))
                new_product_id = int(input("Enter the new unique ID of the product: "))
                name = input("Enter the name: ")
                category = input("Enter the category: ")
                price = int(input("Enter the price of the product: "))

                obj2 = Product(new_product_id, name, category, price)
                f.update_item(product_id, obj2)
            elif choice == '3':
                print("\nEnter the product ID for deleting the product: ")
                e_id = int(input("Enter the product ID for deleting the product: "))
                f.delete_item(e_id)
            elif choice == '4':
                print('\nCurrent Catalog:\n')
                f.display_item()
            elif choice == '6':
                print("\nThank you for using our service. Logging Out!\n")
                break
            else:
                print("\nInvalid Choice\n")
        except ValueError:
            print("Invalid input. Please enter valid values.")
        except Exception as e:
            print(f"An error occurred: {e}")


# User CLI Interface
def usercli():
    """
    CLI for user operations, allowing the user to add items to the cart,
    delete items from the cart, display the cart, and check out.
    """
    session_id = generate_session_id()
    print(f"User session ID: {session_id}")

    f1 = UserFunctions()

    while True:
        try:
            choice = input("Select a Choice:\n1. Add to cart\n2. Delete from cart\n3. Display Cart\n4. Display Catalog\n5. Check Out\n6. Log Out\n")
            if choice == '1':
                print("\nSelect the item to be added\n")
                cart1 = f.return_catalog()
                if len(cart1) == 0:
                    print("Sorry, no items available!")
                    continue
                for i in range(len(cart1)):
                    print(f"Product {i}: \t {cart1[i]}")
                p = int(input("Select the item number: "))
                if p >= len(cart1) or p < 0:
                    print("Invalid product number.")
                    continue
                item1 = cart1[p]
                f1.add_cart(item1)
            elif choice == '2':
                p_id = int(input("Enter product ID for deletion: "))
                f1.delete_cart(p_id)
            elif choice == '3':
                print("\nItems in the cart:\n")
                f1.display_cart()
            elif choice == '4':
                print('\nCurrent Catalog:\n')
                f.display_item()
            elif choice == '5':
                print("\nThank you for shopping with us. Checking Out!\n")
                break
            elif choice == '6':
                print("\nThank you for using our service. Logging Out!\n")
                break
            else:
                print("\nInvalid Choice\n")
        except ValueError:
            print("Invalid input. Please enter valid values.")
        except Exception as e:
            print(f"An error occurred: {e}")


if __name__ == "__main__":
    auth = Authentication()
    while True:
        try:
            user_type = input("Select user type:\n1. Admin\n2. User\n3. Exit\n")
            if user_type == '1':
                username = input("\nEnter admin username: ")
                password = input("Enter admin password: ")
                auth.admin_login(username, password)
            elif user_type == '2':
                username = input("\nEnter user username: ")
                password = input("Enter user password: ")
                auth.user_login(username, password)
            elif user_type == '3':
                print("Exiting the program.")
                break
            else:
                print("\nInvalid Choice\n")
        except Exception as e:
            print(f"An error occurred: {e}")
