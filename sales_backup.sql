
# DATABASE NORMALIZATION ASSIGNMENT
## Question 1: Achieving First Normal Form (1NF)

### 1. Introduction

First Normal Form (1NF) is the first stage of database normalization. A table is in 1NF when:

- Each column contains only atomic (single) values.
- Each row represents a unique record.
- There are no repeating groups or multiple values in a single column.

The original `ProductDetail` table violates 1NF because the `Products` column contains multiple products in one cell.

### 2. Creating the Original Table

```sql
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);
```

### 3. Creating a Normalized Table

To achieve 1NF, we create a new table called `ProductDetail_1NF`, where each product is stored in a separate row.

```sql
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);
```

The composite primary key ensures that each product appears only once per order.

### 4. Inserting Normalized Records

```sql
INSERT INTO ProductDetail_1NF
(OrderID, CustomerName, Product)
VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');
```

### 5. Displaying the Normalized Table

```sql
SELECT * FROM ProductDetail_1NF
ORDER BY OrderID, Product;
```

### 6. Expected Output

| OrderID | CustomerName | Product |
|---|---|---|
| 101 | John Doe | Laptop |
| 101 | John Doe | Mouse |
| 102 | Jane Smith | Tablet |
| 102 | Jane Smith | Keyboard |
| 102 | Jane Smith | Mouse |
| 103 | Emily Clark | Phone |

### 7. Conclusion for Question 1

The `ProductDetail_1NF` table now satisfies First Normal Form because every cell contains a single value, and each row represents one product belonging to a particular order. The repeating groups have been eliminated.

---

# Question 2: Achieving Second Normal Form (2NF)

### 1. Introduction

Second Normal Form (2NF) is the next stage of database normalization.

A table is in 2NF when:

- It already satisfies First Normal Form (1NF).
- Every non-key attribute depends on the entire primary key.
- There are no partial dependencies.

In the original `OrderDetails` table, the composite primary key is `(OrderID, Product)`.

However, `CustomerName` depends only on `OrderID`, not on the entire composite key.

This is called a **partial dependency**, and it violates Second Normal Form.

### 2. Identifying the Partial Dependency

The original table contains the following attributes:

- OrderID
- CustomerName
- Product
- Quantity

The dependencies are:

- OrderID → CustomerName
- (OrderID, Product) → Quantity

The problem is that `CustomerName` depends only on `OrderID`, which is part of the composite primary key.

To solve this problem, we separate the original table into two tables:

1. `Orders` – Stores order information and customer names.
2. `OrderItems` – Stores products and their quantities for each order.

### 3. Creating the Orders Table

The `Orders` table stores each order and the corresponding customer name.

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);
```

The `OrderID` is the primary key because each order must have a unique identifier.

### 4. Creating the OrderItems Table

The `OrderItems` table stores the products and quantities associated with each order.

```sql
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
```

**Explanation:**

- `OrderID` identifies the order.
- `Product` identifies the product in that order.
- `Quantity` records the number of units ordered.
- `(OrderID, Product)` forms the composite primary key.
- `OrderID` is also a foreign key referencing the `Orders` table.

### 5. Inserting Records into the Orders Table

```sql
INSERT INTO Orders (OrderID, CustomerName)
VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');
```

### 6. Inserting Records into the OrderItems Table

```sql
INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);
```

### 7. Displaying the Orders Table

```sql
SELECT * FROM Orders;
```

**Expected Output:**

| OrderID | CustomerName |
|---|---|
| 101 | John Doe |
| 102 | Jane Smith |
| 103 | Emily Clark |

### 8. Displaying the OrderItems Table

```sql
SELECT * FROM OrderItems
ORDER BY OrderID, Product;
```

**Expected Output:**

| OrderID | Product | Quantity |
|---|---|---|
| 101 | Laptop | 2 |
| 101 | Mouse | 1 |
| 102 | Tablet | 3 |
| 102 | Keyboard | 1 |
| 102 | Mouse | 2 |
| 103 | Phone | 1 |

### 9. Joining the Two Tables

To display the complete order information after normalization, we can use an SQL JOIN.

```sql
SELECT
    Orders.OrderID,
    Orders.CustomerName,
    OrderItems.Product,
    OrderItems.Quantity
FROM Orders
INNER JOIN OrderItems
ON Orders.OrderID = OrderItems.OrderID
ORDER BY Orders.OrderID, OrderItems.Product;
```

**Expected Output:**

| OrderID | CustomerName | Product | Quantity |
|---|---|---|---|
| 101 | John Doe | Laptop | 2 |
| 101 | John Doe | Mouse | 1 |
| 102 | Jane Smith | Keyboard | 1 |
| 102 | Jane Smith | Mouse | 2 |
| 102 | Jane Smith | Tablet | 3 |
| 103 | Emily Clark | Phone | 1 |

### 10. Conclusion for Question 2

The original `OrderDetails` table violated Second Normal Form because `CustomerName` depended only on `OrderID`, which was part of the composite primary key.

By separating the data into `Orders` and `OrderItems`, we eliminated the partial dependency.

The `Orders` table stores customer information, while the `OrderItems` table stores products and quantities.

Both tables satisfy Second Normal Form because their non-key attributes depend on their respective primary keys.

---

# GENERAL CONCLUSION

Database normalization is an important process used to organize data efficiently and improve database integrity.

In this assignment:

1. **First Normal Form (1NF):** We eliminated multiple product values in a single cell by storing each product in a separate row.
2. **Second Normal Form (2NF):** We eliminated partial dependencies by separating customer and order information from product and quantity information.

The resulting database structure reduces unnecessary data duplication, improves data consistency, and makes database management easier.
