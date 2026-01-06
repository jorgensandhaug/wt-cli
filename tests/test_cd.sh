#!/usr/bin/env bash
# Tests for wt cd command

test_cd_changes_to_worktree() {
  wt new feature-test >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt cd feature-test
  assert_contains "$PWD" "feature-test" "Should cd to worktree"
}

test_cd_no_arg_goes_to_main() {
  wt new feature-test >/dev/null 2>&1
  # Now we're in feature-test worktree

  wt cd
  # Should be back in main
  local expected actual
  expected=$(cd "$TEST_TEMP/main" && pwd -P)
  actual=$(pwd -P)
  assert_eq "$expected" "$actual" "Should cd to main worktree"
}

test_cd_fails_for_nonexistent() {
  local output
  output=$(wt cd nonexistent 2>&1) || true
  assert_contains "$output" "not found" "Should fail for nonexistent worktree"
}

test_cd_works_with_short_name() {
  wt new my-feature >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt cd my-feature
  assert_contains "$PWD" "my-feature" "Should work with short name"
}

test_cd_works_with_full_path() {
  wt new feature-test >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt cd "$TEST_TEMP/.worktrees/main/feature-test"
  assert_contains "$PWD" "feature-test" "Should work with full path"
}

test_cd_works_with_slashed_branch() {
  wt new feature/auth >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt cd feature/auth
  assert_contains "$PWD" "feature/auth" "Should work with slashed branch name"
}

# Register tests
run_test "wt cd changes to worktree" test_cd_changes_to_worktree
run_test "wt cd without arg goes to main" test_cd_no_arg_goes_to_main
run_test "wt cd fails for nonexistent worktree" test_cd_fails_for_nonexistent
run_test "wt cd works with short name" test_cd_works_with_short_name
run_test "wt cd works with full path" test_cd_works_with_full_path
run_test "wt cd works with slashed branch" test_cd_works_with_slashed_branch
