# Wheelhouse

Wheelhouse is a bicycle repair shop management system designed to help the shop keep track of customers, bicycles, repairs, services, prices, intake photos, diagnoses, and repair history.

## Who uses Wheelhouse?

- **Customers** — review repair information and view the shop's available services and prices.
- **Counter managers** — register customers and bicycles, communicate with customers, record repair charges, manage ownership information, and monitor repairs.
- **Mechanics** — inspect bicycles, perform repairs, add diagnoses, estimate repair times, and consult a bicycle's repair history.
- **Owners/Administrators** — manage services and their prices.

## Documentation

* [User Stories](docs/user-stories.md)
* [Domain Model](docs/domain-model.md)
* [Decisions](docs/decisions.md)
* [Wireframes](docs/wireframes.md)

## Prerequisites

Wheelhouse has been tested with the following environment:

- Windows 10/11
- WSL2 with Ubuntu
- Ruby 4.0.4
- Rails 8.1.3.1
- PostgreSQL
- Node.js
- Yarn 1.22.x
- Git
- libvips

`libvips` is required by Active Storage to generate image variants and thumbnails.

### Installing libvips

On Ubuntu / WSL:

```bash
sudo apt update
sudo apt install libvips-dev
```

Verify the installation with:

```bash
vips --version
```

The project also requires the JavaScript and CSS dependencies declared in `package.json`, including Bootstrap, Bootstrap Icons, Sass, PostCSS, Autoprefixer, and Nodemon.

You can verify the installed versions with:

```bash
ruby -v
bin/rails -v
psql --version
node --version
yarn --version
git --version
vips --version
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
yarn install
```

Make sure PostgreSQL is running and that the database credentials match the configuration in `config/database.yml`.

Create the database, load the schema, and seed the sample data:

```bash
bin/rails db:setup
```

If the database already exists and only needs to be updated, run:

```bash
bin/rails db:prepare
bin/rails db:seed
```

Build the CSS assets:

```bash
yarn build:css
```

Start the application:

```bash
bin/dev
```

Then open:

* http://localhost:3000/
* http://localhost:3000/customers
* http://localhost:3000/bikes
* http://localhost:3000/repairs
* http://localhost:3000/services
* http://localhost:3000/mechanics

The seed data includes repairs with intake photos and formatted diagnoses. After a fresh setup, the repairs index displays generated thumbnails through Active Storage.

Seed images stored under `db/seeds/images/` are local project assets used to provide sample intake photos for development data.

## Main Features

- View customers and their bicycles.
- View bicycles and their repair history.
- View repairs, their assigned mechanics, and their services.
- Upload multiple intake photos for each repair.
- Add new intake photos without replacing existing ones.
- Remove individual intake photos.
- Generate thumbnails and larger image variants with Active Storage.
- Open the original full-size intake photos.
- Validate uploaded images by file type and size.
- Store formatted repair diagnoses with Action Text.
- View formatted diagnoses on repair pages.
- View plain-text diagnosis previews in repair lists.
- View services and their current prices.
- View mechanics and their assigned repairs.
- Navigate between related records using links.
- Identify overdue repairs.
- Handle empty collections gracefully.
- Use responsive Bootstrap tables and navigation.