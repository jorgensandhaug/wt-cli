#!/usr/bin/env bash
# Tests for wt ls command

test_ls_shows_main_worktree() {
  local output
  output=$(wt ls 2>&1)
  assert_contains "$output" "main" "Should show main branch"
}

test_ls_shows_all_worktrees() {
  wt new feature-one >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  local output
  output=$(wt ls 2>&1)
  assert_contains "$output" "feature-one" "Should show created worktree"
}

test_ls_shows_clean_status() {
  local output
  output=$(wt ls 2>&1)
  assert_contains "$output" "[ok]" "Should show clean status"
}

test_ls_shows_dirty_status() {
  echo "dirty" > dirty.txt
  local output
  output=$(wt ls 2>&1)
  assert_contains "$output" "[dirty]" "Should show dirty status"
}

test_ls_fails_outside_repo() {
  cd "$TEST_TEMP"
  local output
  output=$(wt ls 2>&1) || true
  assert_contains "$output" "Not in a git repository" "Should fail outside repo"
}

# Register tests
run_test "wt ls shows main worktree" test_ls_shows_main_worktree
run_test "wt ls shows all worktrees" test_ls_shows_all_worktrees
run_test "wt ls shows clean status" test_ls_shows_clean_status
run_test "wt ls shows dirty status" test_ls_shows_dirty_status
run_test "wt ls fails outside git repo" test_ls_fails_outside_repo
