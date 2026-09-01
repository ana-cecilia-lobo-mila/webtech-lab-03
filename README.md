# Wheelhouse

Wheelhouse is a bicycle repair shop management system designed to help the shop keep track of customers, bicycles, repairs, services, prices, and repair history.

## Who uses Wheelhouse?

- **Customers** — review repair estimates and view the shop's available services and prices.
- **Counter managers** — register customers and bicycles, communicate with customers, record repair charges, manage ownership information, and monitor delayed repairs.
- **Mechanics** — inspect bicycles, document their condition with photos and notes, estimate repair times, perform repairs, and consult a bicycle's repair history.
- **Owners/Administrators** — manage service prices and keep track of price changes over time.

## Documentation

- [User Stories](docs/user-stories.md)
- [Domain Model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Prerequisites

The project is developed and tested using **WSL2 with Ubuntu**.

Before setting up Wheelhouse, make sure the following software is installed:

- **Windows 10/11**
- **WSL2**
- **Ubuntu** on WSL2
- **Ruby 4.0.4**
- **Rails 8.1.3.1**
- **PostgreSQL**
- **Node.js 19.9.0**
- **Yarn 1.22.22**
- **Git**

You can verify the installed versions with:

```bash
ruby -v
rails -v
psql --version
node --version
yarn --version
git --version