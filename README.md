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
- Ruby 3.3.8
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

## API token configuration

Protected API routes require an HTTP Bearer token.

The token is stored in Rails encrypted credentials and is not included directly in the repository.

For a fresh clone, create local development credentials with:

```bash
EDITOR="nano" bin/rails credentials:edit --environment development
```

Add the following configuration:

```yaml
api:
  token: YOUR_API_TOKEN
```

Replace `YOUR_API_TOKEN` with your own token.

The credentials are encrypted by Rails. Do not commit the credentials key or `config/master.key`.

If you already have access to the project's existing Rails credentials and master key, you can edit them with:

```bash
EDITOR="nano" bin/rails credentials:edit
```

## Running Wheelhouse

Start the Rails application:

```bash
bin/rails server
```

The application and API run on port `3000`.

After running `bin/rails db:setup`, use one of the development accounts listed below to sign in.

The HTML application is available at:

* http://localhost:3000/
* http://localhost:3000/customers
* http://localhost:3000/bikes
* http://localhost:3000/repairs
* http://localhost:3000/services
* http://localhost:3000/mechanics

The seed data includes repairs with intake photos and formatted diagnoses. After a fresh setup, the repairs index displays generated thumbnails through Active Storage.

Seed images stored under `db/seeds/images/` are local project assets used to provide sample intake photos for development data.

## Authentication

Wheelhouse uses the native Rails 8 authentication system.

Most pages require a signed-in account. Visitors may access:

- The services list and individual service pages.
- Sign in.
- Sign up.
- Password recovery pages.

Customers do not have accounts.

Each account has one of three roles: `owner`, `counter`, or `mechanic`.

The sign-in page is available at:

```text
http://localhost:3000/session/new
```

The sign-up page is available at:

```text
http://localhost:3000/registration/new
```

## Development accounts

The following accounts are created by `db/seeds.rb` and exist only in development.

| Staff member | Email | Role | Password |
| --- | --- | --- | --- |
| Philip | `philip@wheelhouse.cl` | owner | `PhilipOwner26!` |
| Theo | `theo@wheelhouse.cl` | mechanic | `TheoMechanic26!` |
| Joseph | `joseph@wheelhouse.cl` | mechanic | `JosephMechanic26!` |
| Sara | `sara@wheelhouse.cl` | counter | `SaraCounter26!` |
| No staff member | `staff@wheelhouse.cl` | mechanic | `Standalone26!` |

These credentials are development seed data only and must not be used in production.

## Email in development

Wheelhouse does not use an external mail provider or SMTP server in development.

Development emails are written locally to:

```text
tmp/mails/
```

This includes:

- Password reset emails.
- Welcome emails for newly created accounts.

Password reset links point to the application running locally at `http://localhost:3000`.

Mailer previews are also available while the Rails application is running:

```text
http://localhost:3000/rails/mailers
```

## API

The Wheelhouse JSON API is available under:

```text
http://localhost:3000/api/v1
```

Reading services is public.

Reading repairs and creating services require an HTTP Bearer token.

For all available routes, response formats, status codes, and examples, see the [API Documentation](docs/api.md).

### API examples

Get the public price list:

```bash
curl http://localhost:3000/api/v1/services
```

Access the protected repairs endpoint:

```bash
curl \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  http://localhost:3000/api/v1/repairs
```

Replace `YOUR_API_TOKEN` with the token configured in Rails credentials.

## Published price list

The Wheelhouse price list is displayed on the published personal website:

https://ana-cecilia-lobo-mila.github.io/webtech-lab-01/

The published page fetches the public service list from the Wheelhouse API.

For the published page to find the API, Wheelhouse must be running locally on port `3000`.

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