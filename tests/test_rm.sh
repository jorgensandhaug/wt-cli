#!/usr/bin/env bash
# Tests for wt rm command

test_rm_removes_clean_worktree() {
  wt new feature-test >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt rm feature-test >/dev/null 2>&1
  [[ ! -d "$TEST_TEMP/.worktrees/main/feature-test" ]]
  assert_success "Worktree should be removed"
}

test_rm_warns_on_dirty_worktree() {
  wt new feature-test >/dev/null 2>&1
  echo "dirty" > dirty.txt
  cd "$TEST_TEMP/main"

  local output
  output=$(wt rm feature-test 2>&1) || true
  assert_contains "$output" "uncommitted changes" "Should warn about dirty worktree"
}

test_rm_force_removes_dirty_worktree() {
  wt new feature-test >/dev/null 2>&1
  echo "dirty" > dirty.txt
  cd "$TEST_TEMP/main"

  wt rm -f feature-test >/dev/null 2>&1
  [[ ! -d "$TEST_TEMP/.worktrees/main/feature-test" ]]
  assert_success "Force should remove dirty worktree"
}

test_rm_prevents_removing_main() {
  local output
  output=$(wt rm main 2>&1) || true
  assert_contains "$output" "Cannot remove main" "Should prevent removing main"
}

test_rm_current_worktree_no_arg() {
  wt new feature-test >/dev/null 2>&1
  # Now we're in the feature-test worktree

  wt rm >/dev/null 2>&1
  assert_contains "$PWD" "main" "Should cd back to main"
  [[ ! -d "$TEST_TEMP/.worktrees/main/feature-test" ]]
  assert_success "Current worktree should be removed"
}

test_rm_current_worktree_cds_to_main() {
  wt new feature-test >/dev/null 2>&1

  wt rm >/dev/null 2>&1
  # Should be back in main worktree (use realpath for macOS /var vs /private/var)
  local expected actual
  expected=$(cd "$TEST_TEMP/main" && pwd -P)
  actual=$(pwd -P)
  assert_eq "$expected" "$actual" "Should cd to main worktree"
}

test_rm_fails_for_nonexistent() {
  local output
  output=$(wt rm nonexistent 2>&1) || true
  assert_contains "$output" "not found" "Should fail for nonexistent worktree"
}

test_rm_with_full_path() {
  wt new feature-test >/dev/null 2>&1
  cd "$TEST_TEMP/main"

  wt rm "$TEST_TEMP/.worktrees/main/feature-test" >/dev/null 2>&1
  [[ ! -d "$TEST_TEMP/.worktrees/main/feature-test" ]]
  assert_success "Should remove worktree by full path"
}

# Register tests
run_test "wt rm removes clean worktree" test_rm_removes_clean_worktree
run_test "wt rm warns on dirty worktree" test_rm_warns_on_dirty_worktree
run_test "wt rm -f removes dirty worktree" test_rm_force_removes_dirty_worktree
run_test "wt rm prevents removing main" test_rm_prevents_removing_main
run_test "wt rm without arg removes current" test_rm_current_worktree_no_arg
run_test "wt rm cds back to main" test_rm_current_worktree_cds_to_main
run_test "wt rm fails for nonexistent" test_rm_fails_for_nonexistent
run_test "wt rm with full path" test_rm_with_full_path
