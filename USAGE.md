# Using Halo

Once the development server is running (`bin/rails server`), open your browser to [http://localhost:3000](http://localhost:3000).

## Home Page
The home page (`/`) displays a list of existing snippets (if any are present in the database). From here you can click on a snippet to view its details.

## Creating a New Snippet
Navigate to `/snippets/new` (or click the “New Snippet” button on the home page). Fill in:
- **Title** – a descriptive name for the snippet
- **Language** – the programming language (e.g., `ruby`, `python`, `javascript`) for syntax highlighting
- **Code** – the actual code content

Click “Create Snippet”. You will be redirected to the newly created snippet’s page.

## Viewing a Snippet
Each snippet has its own page at `/snippets/:id`. The page shows:
- Syntax‑highlighted code (powered by Rouge)
- Copy button (click to copy code to clipboard)
- Shareable URL (use this link to share with others)

## Dark Mode
Toggle between light and dark themes using the theme switcher (a sun/moon icon in the navigation bar). Your preference is persisted in local storage.

## Demo Data
To populate the database with sample snippets, run:
```bash
bin/rails db:seed
```
Refresh the home page to see the demo snippets.