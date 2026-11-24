# Test-7Days-Supabase

A small test to check that a scheduled GitHub Action keeps a free-plan Supabase project from being paused for inactivity.

## How it works

- Every 12 hours, a GitHub Action calls the project's `keepalive_ping` function through the Supabase API.
- The function stamps the time and adds 1 to a counter on a single row in the `keepalive` table.
- Supabase sees regular activity, so it does not pause the project.

## Setup

1. Run `supabase/migrations/20261124000000_create_keepalive.sql` in the Supabase SQL Editor (already applied to this project).
2. In this repo, go to Settings > Secrets and variables > Actions and add a secret named `SUPABASE_PUBLISHABLE_KEY` with the project's publishable (public) key.
3. Open the Actions tab, choose "Supabase keepalive" and click "Run workflow" to test it.

## How to check it is working

In Supabase, open Table Editor > `keepalive`. `last_ping` should show a recent time, `ping_count` should go up by about 2 each day, and `last_ping_source` should name the GitHub run.
