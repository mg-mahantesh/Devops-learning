trap "echo Nope! Can't quit now." SIGINT
while true; do
  echo "Running... (try Ctrl+C)"
  sleep 2
done

