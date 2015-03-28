class Edge {

  public String startLemmas; 
  public String endLemmas; 
  public String start;  //e.g. /c/en/face 
  public String end;  //e.g. /c/en/nose 
  //public String surfaceText; //the sentence connecting the edge to the node //can't find this in the object for some reason 
  public String rel; //language independent relations
  public boolean isStart = true;
  public String newName = "";

  public Edge(String startLemmas, String endLemmas, String start, String end, String rel, String newName) {
    this.startLemmas = startLemmas;
    this.endLemmas = endLemmas;
    this.start = start;
    this.end = end; 
    //this.surfaceText = surfaceText; //CAN'T FIND IN JSON OBJECT??
    this.rel = rel;

    if (newName.contains("_")) {
      String[] splitted = split(newName, "_");
      for (int i = 0; i < splitted.length; i++) {
        if (i != splitted.length - 1) {
          this.newName += splitted[i] + " ";
        } else {
          this.newName += splitted[i];
        }
      }
    } else {
      this.newName = newName;
    }
  }



  public Edge(String startLemmas, String endLemmas, String start, String end, String rel, boolean isStart) {
    this.startLemmas = startLemmas;
    this.endLemmas = endLemmas;
    this.start = start;
    this.end = end; 
    //this.surfaceText = surfaceText; //CAN'T FIND IN JSON OBJECT??
    this.rel = rel;
    this.isStart = isStart;
  }
}

