final int edgeLimit = 10; 
final String path = "http://conceptnet5.media.mit.edu/data/5.2";

final String REL_IS_A = "/r/IsA";
final String REL_USED_FOR = "/r/UsedFor";

Edge[] unownedEdges;
JSONObject unownedJson;

CNObject object;

void setup() { 
  size(400, 400); 
  background(#EEEEEE); 
  frameRate(30);
  object = new CNObject("/c/en/human", "human");
  //  object.getAllEdges();
  //  object.listEdges();
  //  object.printAttributes();



  int total = getNumFound(true, REL_IS_A, "end", "/c/en/person/n", 100, 100);
  getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person/n", 100,99);// (int)random(1,100)); //limit of 1000, offset of 0
  listUnownedEdgesNames();

//  getRelTypeEdgeOf(false, REL_IS_A, "end", "/c/en/person", 100, 0); //limit of 1000, offset of 0
//  listUnownedEdgesNames();
  //  
  //  getRelTypeEdgeOf(true, REL_IS_A, "end", "/c/en/person/n", 1, (int)random(100));
  //  listUnownedEdgesNames();
  //  
  ////  
  //  getRelTypeEdgeOf(false, "", "", "/c/en/person/n", 1, (int)random(100));
  //  listUnownedEdgesNames();

  //  getRelTypeEdgesOf(REL_IS_A, "end", "/c/en/person");
  //  listUnownedEdges();

  //  getGeneralEdgesOf("/c/en/human/n/");
  //  listUnownedEdges();
}


//get path
public String getPath(String searchObject, boolean relTrue, String relString, String startOrEnd, int limitNum, int offsetNum) { 
  String newPath = "";
  // relation search, single query
  if (relTrue && offsetNum > 0) {//offsetTrue) {
    newPath = path + "/search?rel=" + relString + "&" + startOrEnd + "=" + searchObject + "&limit=" + limitNum + "&offset=" + offsetNum + "&filter=/c/en";
  } 
  //relation search, normal (limited) query
  if (relTrue && offsetNum == 0) {//!offsetTrue) { 
    newPath = path + "/search?rel=" + relString + "&" + startOrEnd + "=" + searchObject + "&limit=" + limitNum + "&filter=/c/en";
  } 
  // no relation search, normal (limited) query
  if (!relTrue && offsetNum == 0) {//!offsetTrue) {
    newPath = path + searchObject + "?limit=" + limitNum + "&filter=/c/en";
  }
  // no relation search, single query
  if (!relTrue && offsetNum > 0){//offsetTrue) {
    newPath = path + searchObject + "?limit=" + limitNum + "&offset=" + offsetNum + "&filter=/c/en";
  } 
  println("calculated path is " + newPath); 
  return newPath;
} 

//get edges at offset number optionally defined by a relationship (i.e. "/r/IsA"), 
public void getSomeEdgeOf(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum) {
  unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  JSONArray jsonEdges = unownedJson.getJSONArray("edges");
  JSONObject edge;
  String startLemmas, endLemmas, start, end, rel;
  String newName = "";
  unownedEdges = new Edge[jsonEdges.size()];
  for (int i = 0; i < unownedEdges.length; i++) { 
    edge = jsonEdges.getJSONObject(i);
    startLemmas = edge.getString("startLemmas"); 
    endLemmas = edge.getString("endLemmas"); 
    start = edge.getString("start");
    end = edge.getString("end");
    rel = edge.getString("rel");

    if (end.contains(otherObject)) {
      String splitString[] = split(start, "/");
      //println(splitString[3] + " (start)");
      newName = splitString[3];
    } else if (start.contains(otherObject)) {
      String splitString[] = split(end, "/");
      //println(splitString[3] + " (end)");
      newName = splitString[3];
    } else { 
      newName = "???";
    }

    unownedEdges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newName);
  }
}

public int getNumFound(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum) {
  unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  int numFound = unownedJson.getInt("numFound");
  return numFound; 
} 

public void listUnownedEdgesNames() { 
  for (int i = 0; i < unownedEdges.length; i++) {
    println(unownedEdges[i].newName);
  }
} 

//---THIS ONE IS KINDA USELESS NOW IN LIGHT OF listUnownedEdgesNames()
public void listUnownedEdges() { 
  for (int i = 0; i < unownedEdges.length; i++) {
    print(unownedEdges[i].start + " -- ");
    print(unownedEdges[i].startLemmas + " --> "); 
    print(unownedEdges[i].end + " -- ");
    println(unownedEdges[i].endLemmas);
  }
} 
