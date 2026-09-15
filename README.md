# Wheelhouse

Wheelhouse is a bicycle repair shop management system designed to help the shop keep track of customers, bicycles, repairs, services, prices, and repair history.

## Who uses Wheelhouse?

* **Customers** — review repair information and view the shop's available services and prices.
* **Counter managers** — register customers and bicycles, communicate with customers, record repair charges, manage ownership information, and monitor repairs.
* **Mechanics** — inspect bicycles, perform repairs, estimate repair times, and consult a bicycle's repair history.
* **Owners/Administrators** — manage services and their prices.

## Documentation

* [User Stories](docs/user-stories.md)
* [Domain Model](docs/domain-model.md)
* [Decisions](docs/decisions.md)
* [Wireframes](docs/wireframes.md)

## Prerequisites

The project is developed and tested using **WSL2 with Ubuntu**.

Before setting up Wheelhouse, make sure the following software is installed:

* **Windows 10/11**
* **WSL2**
* **Ubuntu** on WSL2
* **Ruby 4.0.4**
* **Rails 8.1.3.1**
* **PostgreSQL**
- **Node.js 26.8.1**
* **Yarn 1.22.22**
* **Git**

You can verify the installed versions with:

```bash
ruby -v
rails -v
psql --version
node --version
yarn --version
git --version
```

## Setup

Clone the repository and move into the project directory:

```bash
git clone https://github.com/ana-cecilia-lobo-mila/webtech-lab-03
cd webtech-lab-03
```

Install the dependencies:

```bash
bundle install
```

Create and prepare the database:

```bash
bin/rails db:setup
```

Start the Rails server:

```bash
bin/rails server
```

Then open:

* http://localhost:3000/
* http://localhost:3000/customers
* http://localhost:3000/bikes
* http://localhost:3000/repairs
* http://localhost:3000/services
* http://localhost:3000/mechanics

The `db:setup` command creates the database, loads the schema, and seeds the sample data.

## Main Features

* View customers and their bicycles.
* View bicycles and their repair history.
* View repairs, their assigned mechanics, and their services.
* View services and their current prices.
* View mechanics and their assigned repairs.
* Navigate between related records using links.
* Identify overdue repairs.
* Handle empty collections gracefully.
* Use responsive Bootstrap tables and navigation.
