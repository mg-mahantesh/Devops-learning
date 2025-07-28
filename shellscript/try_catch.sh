#!/bin/bash

# Try block - commands that might fail
{
  echo "This is the try block"
  
  # Example command that fails (exit code non-zero)
  ls /nonexistent_folder
  
  echo "This line will NOT execute if above command fails"
} || {
  # Catch block - runs if any command in try block fails
  echo "An error occurred during the try block execution."
}


