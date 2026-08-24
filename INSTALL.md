# Installing Halo

## 1. Prerequisites
- Ruby **3.3.11** (as specified in `.ruby-version`)
- Bundler (`gem install bundler`)
- (Optional) Docker for production deployment (Dockerfile included)

## 2. Get the Code
Clone the repository:
```bash
git clone <repository-url>
cd halo
```

## 3. Install Dependencies
Install all Ruby gems:
```bash
bundle install
```

## 4. Environment Variables
The application relies on several environment variables. Copy the example file and edit it with your own values:
```bash
cp .env.example .env
```
Edit `.env` and set the following variables:
- `NEW_KEY`
- `RAILS_MASTER_KEY` — needed to decrypt Rails credentials; obtain it from your team or generate with `bin/rails secret`
- `SECRET`
- `TMP_EDITOR`
- `TMP_YML`

## 5. Database Setup
The app uses SQLite. Create the database and run migrations:
```bash
ruby bin/rails db:migrate
```
(Optionally, load demo data: `ruby bin/rails db:seed`)

## 6. Development Server
Start the Rails development server:
```bash
bin/rails server
```
The application will be available at `http://localhost:3000`.

## 7. Running Tests
Execute the test suite:
```bash
bin/rails test
```

## 8. Production Build
Precompile assets for production:
```bash
bin/rails assets:precompile
```
Then start the server in production mode:
```bash
RAILS_ENV=production bin/rails server
```
Alternatively, use the provided Dockerfile to build a production image.

## Troubleshooting
- **Missing `bundle` command?** Run `gem install bundler`.
- **Ruby version mismatch?** Ensure you have Ruby 3.3.11 installed. Use a version manager like rbenv or rvm.
- **`RAILS_MASTER_KEY` not set?** In production, you must provide the master key via the environment variable or a `config/master.key` file.
- **Assets not loading?** Run `bin/rails assets:precompile` and verify that `RAILS_MASTER_KEY` is set during build.