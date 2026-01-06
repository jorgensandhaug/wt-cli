#!/usr/bin/env bash
# wt-cli test runner
# Simple test framework for shell functions

set -e

# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
RESET=$'\033[0m'

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test temp directory
TEST_TEMP=""

# Setup test environment
setup_test_env() {
  TEST_TEMP=$(mktemp -d)
  cd "$TEST_TEMP"

  # Create a bare repo to act as "remote"
  git init --bare remote.git >/dev/null 2>&1

  # Create main repo
  git clone remote.git main >/dev/null 2>&1
  cd main
  echo "# Test repo" > README.md
  git add README.md
  git commit -m "Initial commit" >/dev/null 2>&1
  git push -u origin main >/dev/null 2>&1

  # Source wt.sh
  source "$SCRIPT_DIR/../wt.sh"
}

# Cleanup test environment
cleanup_test_env() {
  cd /
  if [[ -n "$TEST_TEMP" ]] && [[ -d "$TEST_TEMP" ]]; then
    rm -rf "$TEST_TEMP"
  fi
}

# Assert functions
assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-Values should be equal}"

  if [[ "$expected" == "$actual" ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local msg="${3:-String should contain substring}"

  if [[ "$haystack" == *"$needle"* ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    echo "  String: $haystack"
    echo "  Should contain: $needle"
    return 1
  fi
}

assert_dir_exists() {
  local dir="$1"
  local msg="${2:-Directory should exist}"

  if [[ -d "$dir" ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    echo "  Directory does not exist: $dir"
    return 1
  fi
}

assert_file_exists() {
  local file="$1"
  local msg="${2:-File should exist}"

  if [[ -f "$file" ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    echo "  File does not exist: $file"
    return 1
  fi
}

assert_success() {
  local msg="${1:-Command should succeed}"

  if [[ $? -eq 0 ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    return 1
  fi
}

assert_failure() {
  local exit_code=$?
  local msg="${1:-Command should fail}"

  if [[ $exit_code -ne 0 ]]; then
    return 0
  else
    echo "${RED}FAIL${RESET}: $msg"
    return 1
  fi
}

# Run a single test
run_test() {
  local test_name="$1"
  local test_func="$2"

  TESTS_RUN=$((TESTS_RUN + 1))

  # Setup fresh environment for each test
  setup_test_env

  printf "  %-50s " "$test_name"

  # Run test in subshell to catch failures
  if (set -e; $test_func) 2>/dev/null; then
    echo "${GREEN}PASS${RESET}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "${RED}FAIL${RESET}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  # Cleanup
  cleanup_test_env
}

# Run all tests in a file
run_test_file() {
  local file="$1"
  local file_name=$(basename "$file" .sh)

  echo ""
  echo "${YELLOW}Running $file_name tests...${RESET}"

  source "$file"
}

# Print summary
print_summary() {
  echo ""
  echo "=================================="
  echo "Tests run:    $TESTS_RUN"
  echo "Tests passed: ${GREEN}$TESTS_PASSED${RESET}"
  echo "Tests failed: ${RED}$TESTS_FAILED${RESET}"
  echo "=================================="

  if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
  fi
}

# Main
main() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  echo "wt-cli test suite"
  echo "=================="

  # Run all test files
  for test_file in "$SCRIPT_DIR"/test_*.sh; do
    if [[ -f "$test_file" ]] && [[ "$test_file" != *"test_runner.sh"* ]]; then
      run_test_file "$test_file"
    fi
  done

  print_summary
}

# Only run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
