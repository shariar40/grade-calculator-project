#!/bin/bash

DATABASE_FILE="inventory.db"



# Function to initialize the database
initialize_database() {
    if [[ -f "$DATABASE_FILE" ]]; then
        echo "Database already exists."
        return
    fi

    sqlite3 "$DATABASE_FILE" < schema.sql
    echo "Database created successfully."
}

# Function to add a new product to the inventory
add_product() {
    echo "Enter product details:"
    read -p "Name: " name
    read -p "Quantity: " quantity
    read -p "Price: " price

    sqlite3 "$DATABASE_FILE" "INSERT INTO products (name, quantity, price) VALUES ('$name', $quantity, $price);"
    echo "Product added successfully."
}

# Function to display the list of products in the inventory
list_products() {
    sqlite3 -separator ' | ' -header "$DATABASE_FILE" "SELECT * FROM products;"
}

# Function to update the quantity of a product
update_quantity() {
    read -p "Enter the ID of the product: " id
    read -p "Enter the new quantity: " quantity

    sqlite3 "$DATABASE_FILE" "UPDATE products SET quantity = $quantity WHERE id = $id;"
    echo "Quantity updated successfully."
}

# Function to update the price of a product
update_price() {
    read -p "Enter the ID of the product: " id
    read -p "Enter the new price: " price

    sqlite3 "$DATABASE_FILE" "UPDATE products SET price = $price WHERE id = $id;"
    echo "Price updated successfully."
}

# Function to update the name of a product
update_name() {
    read -p "Enter the ID of the product: " id
    read -p "Enter the new name: " name

    sqlite3 "$DATABASE_FILE" "UPDATE products SET name = '$name' WHERE id = $id;"
    echo "Name updated successfully."
}

# Function to delete a product from the inventory
delete_product() {
    read -p "Enter the ID of the product: " id

    sqlite3 "$DATABASE_FILE" "DELETE FROM products WHERE id = $id;"
    echo "Product deleted successfully."
}

# Function to search for a product by name
search_product() {
    read -p "Enter the name or part of the name of the product: " search_term

    sqlite3 -separator ' | ' -header "$DATABASE_FILE" "SELECT * FROM products WHERE name LIKE '%$search_term%';"
}

# Main menu
while true; do
    echo "-------------------"
    echo "Inventory Management System"
    echo "-------------------"
    echo "1. Initialize Database"
    echo "2. Add Product"
    echo "3. List Products"
    echo "4. Update Quantity"
    echo "5. Update Price"
    echo "6. Update Name"
    echo "7. Delete Product"
    echo "8. Search Product"
    echo "9. Exit"
    echo "-------------------"

    read -p "Enter your choice (1-9): " choice

    case $choice in
        1)
            initialize_database
            ;;
        2)
            add_product
            ;;
        3)
            list_products
            ;;
        4)
            update_quantity
            ;;
        5)
            update_price
            ;;
        6)
            update_name
            ;;
        7)
            delete_product
            ;;
        8)
            search_product
            ;;
        9)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
