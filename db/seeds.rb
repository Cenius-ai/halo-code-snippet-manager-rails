puts "Seeding snippets..."

snippets_data = [
  {
    title: "Ruby quicksort implementation",
    language: "ruby",
    content: <<~'RUBY'
      def quicksort(arr)
        return arr if arr.length <= 1

        pivot = arr.sample
        left  = arr.select { |x| x < pivot }
        mid   = arr.select { |x| x == pivot }
        right = arr.select { |x| x > pivot }

        quicksort(left) + mid + quicksort(right)
      end

      # Example usage
      data = [7, 2, 1, 6, 8, 5, 3, 4]
      sorted = quicksort(data)
      puts "Sorted: #{sorted.inspect}"
    RUBY
  },
  {
    title: "Python decorator for timing",
    language: "python",
    content: <<~'PYTHON'
      import time
      from functools import wraps

      def timer(func):
          """Decorator that prints the runtime of the decorated function."""
          @wraps(func)
          def wrapper(*args, **kwargs):
              start = time.perf_counter()
              result = func(*args, **kwargs)
              elapsed = time.perf_counter() - start
              print(f"{func.__name__} took {elapsed:.4f}s")
              return result
          return wrapper

      @timer
      def compute_fibonacci(n):
          a, b = 0, 1
          for _ in range(n):
              a, b = b, a + b
          return a

      print(compute_fibonacci(100_000))
    PYTHON
  },
  {
    title: "React custom hook for localStorage",
    language: "javascript",
    content: <<~'JS'
      import { useState, useEffect, useCallback } from 'react';

      export function useLocalStorage(key, initialValue) {
        const [storedValue, setStoredValue] = useState(() => {
          try {
            const item = window.localStorage.getItem(key);
            return item ? JSON.parse(item) : initialValue;
          } catch (error) {
            console.warn(`Error reading localStorage key "${key}":`, error);
            return initialValue;
          }
        });

        const setValue = useCallback((value) => {
          try {
            const valueToStore = value instanceof Function
              ? value(storedValue)
              : value;
            setStoredValue(valueToStore);
            window.localStorage.setItem(key, JSON.stringify(valueToStore));
          } catch (error) {
            console.warn(`Error setting localStorage key "${key}":`, error);
          }
        }, [key, storedValue]);

        return [storedValue, setValue];
      }
    JS
  },
  {
    title: "CSS grid responsive layout",
    language: "css",
    content: <<~'CSS'
      /* Auto-fit grid with minimum column width */
      .gallery {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem;
        padding: 2rem;
      }

      .gallery > .card {
        background: var(--color-card, #fffefb);
        border: 1px solid var(--color-border, #e5dcd7);
        border-radius: 0; /* paper-and-ink: flat */
        padding: 1.25rem;
        transition: border-color 300ms ease-in-out;
      }

      .gallery > .card:hover {
        border-color: var(--color-accent, #c66846);
      }

      @media (max-width: 640px) {
        .gallery {
          grid-template-columns: 1fr;
          gap: 1rem;
          padding: 1rem;
        }
      }
    CSS
  },
  {
    title: "SQL query for monthly revenue",
    language: "sql",
    content: <<~'SQL'
      WITH monthly_sales AS (
        SELECT
          DATE_TRUNC('month', created_at) AS month,
          SUM(amount_cents) / 100.0 AS revenue,
          COUNT(*) AS order_count
        FROM orders
        WHERE status = 'completed'
          AND created_at >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12 months'
        GROUP BY DATE_TRUNC('month', created_at)
      )
      SELECT
        month,
        revenue,
        order_count,
        ROUND(revenue / NULLIF(order_count, 0), 2) AS avg_order_value,
        ROUND(
          100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
            / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
          1
        ) AS pct_change
      FROM monthly_sales
      ORDER BY month DESC;
    SQL
  },
  {
    title: "Bash backup script with rotation",
    language: "bash",
    content: <<~'BASH'
      #!/usr/bin/env bash
      set -euo pipefail

      BACKUP_DIR="/var/backups/app"
      RETENTION_DAYS=14
      TIMESTAMP=$(date +%Y%m%d_%H%M%S)
      BACKUP_FILE="${BACKUP_DIR}/app_backup_${TIMESTAMP}.tar.gz"

      mkdir -p "${BACKUP_DIR}"

      echo "[$(date)] Starting backup to ${BACKUP_FILE}"

      tar -czf "${BACKUP_FILE}" \
        -C /opt/app \
        --exclude='*.log' \
        --exclude='tmp/*' \
        --exclude='node_modules/*' \
        data/ config/

      # Rotate old backups
      find "${BACKUP_DIR}" -name "app_backup_*.tar.gz" -mtime "+${RETENTION_DAYS}" -delete

      echo "[$(date)] Backup complete. Size: $(du -h "${BACKUP_FILE}" | cut -f1)"
    BASH
  },
  {
    title: "Go worker pool pattern",
    language: "go",
    content: <<~'GO'
      package main

      import (
        "fmt"
        "sync"
      )

      func worker(id int, jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
        defer wg.Done()
        for j := range jobs {
          fmt.Printf("Worker %d processing job %d\n", id, j)
          results <- j * 2
        }
      }

      func main() {
        const numJobs = 20
        const numWorkers = 4

        jobs := make(chan int, numJobs)
        results := make(chan int, numJobs)
        var wg sync.WaitGroup

        for w := 1; w <= numWorkers; w++ {
          wg.Add(1)
          go worker(w, jobs, results, &wg)
        }

        for j := 1; j <= numJobs; j++ {
          jobs <- j
        }
        close(jobs)

        go func() {
          wg.Wait()
          close(results)
        }()

        for r := range results {
          fmt.Println("Result:", r)
        }
      }
    GO
  },
  {
    title: "Hello world in HTML",
    language: "html",
    content: <<~'HTML'
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hello, world</title>
        <style>
          body {
            font-family: system-ui, sans-serif;
            display: grid;
            place-items: center;
            min-height: 100dvh;
            margin: 0;
            background: #fff8f3;
            color: #1b1008;
          }
          h1 { font-weight: 600; }
        </style>
      </head>
      <body>
        <h1>Hello, world 👋</h1>
      </body>
      </html>
    HTML
  },
  {
    title: "JSON configuration example",
    language: "json",
    content: <<~'JSON'
      {
        "name": "halo",
        "version": "1.0.0",
        "description": "A developer's code snippet manager",
        "scripts": {
          "start": "bundle exec rails server",
          "seed": "ruby bin/rails db:seed"
        },
        "features": [
          "syntax_highlighting",
          "short_urls",
          "raw_content",
          "dark_mode",
          "copy_to_clipboard"
        ]
      }
    JSON
  },
  {
    title: "Simple Markdown preview",
    language: "markdown",
    content: <<~'MD'
      # Halo — Code Snippet Manager

      A developer-friendly **pastebin** for sharing code.

      ## Features

      - Syntax highlighting via Rouge
      - Short, shareable URLs
      - Raw text view for curl / wget
      - Dark & light themes
      - No account needed

      ## Usage

      ```
      # Create a snippet via the web form
      ```

      > "Simple things should be simple." — Alan Kay
    MD
  }
]

snippets_data.each do |data|
  Snippet.find_or_create_by!(title: data[:title]) do |s|
    s.language = data[:language]
    s.content  = data[:content]
  end
end

puts "Seeded #{Snippet.count} snippets."
