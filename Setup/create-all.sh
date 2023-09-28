#!/bin/bash

# Define an array of values
# declare -a ids=("0001" "0002" "0003")
# declare -a ids=("1506007" "1541674" "1497172" "1542352" "1536740" "1542675" "1536123" "1542897" "1527574" "1542293" "1536865" "1536731" "1542125" "1525759" "1537675" "1505897" "1511142" "1536977" "1534758" "1542301" "1537856" "1540904" "1542583" "1505897" "1511142" )
declare -a ids=("1525759" "1534758" "1536977" "1537675" "1537856" "1540904" "1542301" "1542583")

# Iterate over the ids
for id in "${ids[@]}"
do
  # Call the create resources script
  echo "Creating resources for $id"
  ./create-resources.sh "$id" $1
done