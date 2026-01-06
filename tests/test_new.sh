#!/usr/bin/env bash
# Tests for wt new command

test_new_creates_worktree() {
  wt new feature-test >/dev/null 2>&1
  assert_dir_exists "$TEST_TEMP/.worktrees/main/feature-test" "Worktree directory should be created"
}

test_new_creates_branch() {
  wt new feature-test >/dev/null 2>&1
  cd "$TEST_TEMP/main"
  local branches=$(git branch -a)
  assert_contains "$branches" "feature-test" "Branch should be created"
}

test_new_changes_directory() {
  wt new feature-test >/dev/null 2>&1
  assert_contains "$PWD" "feature-test" "Should cd into new worktree"
}

test_new_fails_without_arg() {
  local output
  output=$(wt new 2>&1) || true
  assert_contains "$output" "Usage" "Should show usage message"
}

test_new_fails_outside_repo() {
  cd "$TEST_TEMP"
  local output
  output=$(wt new test 2>&1) || true
  assert_contains "$output" "Not in a git repository" "Should fail outside repo"
}

test_new_existing_branch_local() {
  # Create a branch first
  cd "$TEST_TEMP/main"
  git checkout -b existing-branch >/dev/null 2>&1
  git checkout main >/dev/null 2>&1

  wt new -b existing-branch >/dev/null 2>&1
  assert_dir_exists "$TEST_TEMP/.worktrees/main/existing-branch" "Worktree should be created for existing branch"
}

test_new_handles_dashes_in_name() {
  wt new my-feature >/dev/null 2>&1
  assert_dir_exists "$TEST_TEMP/.worktrees/main/my-feature" "Should handle feature names with dashes"
}

test_new_handles_slashes_in_name() {
  wt new feature/auth >/dev/null 2>&1
  assert_dir_exists "$TEST_TEMP/.worktrees/main/feature/auth" "Should handle feature names with slashes"
}

# Register tests
run_test "wt new creates worktree directory" test_new_creates_worktree
run_test "wt new creates branch" test_new_creates_branch
run_test "wt new changes to new directory" test_new_changes_directory
run_test "wt new fails without argument" test_new_fails_without_arg
run_test "wt new fails outside git repo" test_new_fails_outside_repo
run_test "wt new -b uses existing branch" test_new_existing_branch_local
run_test "wt new handles dashes in name" test_new_handles_dashes_in_name
run_test "wt new handles slashes in name" test_new_handles_slashes_in_name
