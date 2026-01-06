#!/usr/bin/env bash
# Tests for misc wt commands (version, config, prune, help)

test_version_shows_version() {
  local output
  output=$(wt version 2>&1)
  assert_contains "$output" "wt version" "Should show version"
}

test_version_flag() {
  local output
  output=$(wt --version 2>&1)
  assert_contains "$output" "wt version" "Should work with --version flag"
}

test_config_shows_path() {
  local output
  output=$(wt config 2>&1)
  assert_contains "$output" "config/wt/config.json" "Should show config path"
}

test_help_shows_commands() {
  local output
  output=$(wt 2>&1)
  assert_contains "$output" "Commands:" "Should show commands"
  assert_contains "$output" "wt new" "Should list new command"
  assert_contains "$output" "wt ls" "Should list ls command"
}

test_prune_runs() {
  local output
  output=$(wt prune 2>&1)
  assert_contains "$output" "Pruning" "Should run prune"
}

test_unknown_command_shows_error() {
  local output
  output=$(wt foobar 2>&1) || true
  assert_contains "$output" "Unknown command" "Should show unknown command error"
  assert_contains "$output" "foobar" "Should include the invalid command"
}

# Register tests
run_test "wt version shows version" test_version_shows_version
run_test "wt --version works" test_version_flag
run_test "wt config shows path" test_config_shows_path
run_test "wt help shows commands" test_help_shows_commands
run_test "wt prune runs" test_prune_runs
run_test "wt unknown cmd shows error" test_unknown_command_shows_error
