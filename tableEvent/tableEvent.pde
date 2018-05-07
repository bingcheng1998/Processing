  
Table table;

void setup() {

  table = new Table();
  
  table.addColumn("name");
  table.addColumn("type");
  
  TableRow newRow = table.addRow();
  newRow.setString("name", "Lion");
  newRow.setString("type", "Mammal");
  println(table.getRowCount());  // Prints 1
  
  table.addRow();  // Creates a new blank row
  println(table.getRowCount());  // Prints 2
  
  table.addRow(newRow);  // Duplicates newRow
  println(table.getRowCount());  // Prints 3
  
  for(int i = 0; i<10; i++){
  newRow = table.addRow();
  newRow.setString("name", "Lion");
  newRow.setString("type", "Mammal");
  println(table.getRowCount());  // Prints 
  }
  
  String TXTname = "Sensor"+"-" + str(day()) + "-" + str(hour()) + "-" + str(minute())+"-"+str(second());
  saveTable(table, "RawData/"+TXTname,"csv");
}
