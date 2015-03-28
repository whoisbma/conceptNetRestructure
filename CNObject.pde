class CNObject { 
  JSONObject json;
  Edge[] edges;
  String address;
  String thisName;

  public CNObject(String address, String thisName) {
    this.address = address;
    this.thisName = thisName; 
    this.json = loadJSONObject(path+address+ "?limit="+edgeLimit);
  }
  
  public void printAttributes() {
    println("address is " + address); 
    println("thisName is " + thisName);
    println("json path is " + path+address + "?limit="+edgeLimit);
    println("json edges number " + edges.length); 
  }
  
  
  public void getAllEdges() { 
    JSONArray jsonEdges = json.getJSONArray("edges");
    JSONObject edge;
    String startLemmas;
    String endLemmas;
    String start;
    String end;
    String rel;
    boolean newEdgeIsStart = true;
    edges = new Edge[jsonEdges.size()];
    for (int i = 0; i < jsonEdges.size(); i++) { 
      edge = jsonEdges.getJSONObject(i);
      startLemmas = edge.getString("startLemmas"); 
      endLemmas = edge.getString("endLemmas"); 
      start = edge.getString("start");
      end = edge.getString("end");
      rel = edge.getString("rel");
      if (address.equals(start)) {
        println("START MATCH, " + start + " " + address + " PICKED END: " + end); 
        newEdgeIsStart = false;
      } else if (address.equals(end)) {
        println("END MATCH, " + end + " " + address + " PICKED START: " + start); 
        newEdgeIsStart = true;
      } else { 
        println("NO MATCH between " + start + " and " + end + " and " + address + ", PICKED DEFAULT (end): " + end );
        println("(not sure i should even make it an edge in this case)"); 
        newEdgeIsStart = false;
      }
      edges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newEdgeIsStart);
    }
  } 
  
  public void listEdges() {
     for (int i = 0; i < edges.length; i++) {
       if (edges[i].isStart) {
         println(edges[i].start);
       } else { 
         println(edges[i].end);
       }
     } 
  } 

  
}
