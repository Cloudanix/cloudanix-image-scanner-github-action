#!/bin/bash
# Runs entrypoint.sh against a fake `imagescanner` and checks which scanner
# exit codes fail the step. Usage: tests/entrypoint_test.sh
set -u
cd "$(dirname "$0")/.." || exit 1

fake_bin=$(mktemp -d)
trap 'rm -rf "$fake_bin"' EXIT
cat > "$fake_bin/imagescanner" <<'EOF'
#!/bin/bash
[ -n "${FAKE_SCANNER_ECHO:-}" ] && echo "$*"
exit "$FAKE_SCANNER_EXIT"
EOF
chmod +x "$fake_bin/imagescanner"

failures=0
# scanner exit code -> expected entrypoint exit code
for case in "0 0" "3 3" "1 0" "2 0" "125 0" "137 0"; do
  read -r scanner_exit expected <<<"$case"
  output=$(FAKE_SCANNER_EXIT=$scanner_exit PATH="$fake_bin:$PATH" bash entrypoint.sh -a img -b tok -c id -d false -e false)
  actual=$?
  if [ "$actual" -ne "$expected" ]; then
    echo "FAIL: scanner exit $scanner_exit -> entrypoint exit $actual, want $expected"
    failures=$((failures + 1))
  fi
  if [ "$expected" -eq 0 ] && [ "$scanner_exit" -ne 0 ] && [[ "$output" != *"::warning::"* ]]; then
    echo "FAIL: scanner exit $scanner_exit produced no ::warning:: annotation"
    failures=$((failures + 1))
  fi
done

# debug-mode value -> whether --debugMode reaches the scanner
for case in "_ no" "false no" "true yes" "TRUE yes"; do
  read -r debug want <<<"$case"
  [ "$debug" = "_" ] && debug=""
  output=$(FAKE_SCANNER_EXIT=0 FAKE_SCANNER_ECHO=1 PATH="$fake_bin:$PATH" bash entrypoint.sh -a img -b tok -c id -d false -e "$debug")
  got=no
  [[ "$output" == *"--debugMode true"* ]] && got=yes
  if [ "$got" != "$want" ]; then
    echo "FAIL: debug-mode '$debug' -> --debugMode passed: $got, want $want"
    failures=$((failures + 1))
  fi
done

[ "$failures" -eq 0 ] && echo "PASS" || exit 1
