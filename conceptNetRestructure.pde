final int edgeLimit = 10; 
final String path = "http://conceptnet5.media.mit.edu/data/5.2";

final String REL_IS_A = "/r/IsA";
final String REL_USED_FOR = "/r/UsedFor";

Edge[] unownedEdges;
JSONObject unownedJson;

//CNObject object;

void setup() { 
  size(400, 400); 
  background(#EEEEEE); 
  frameRate(30);
  //object = new CNObject("/c/en/human", "human");
  //  object.getAllEdges();
  //  object.listEdges();
  //  object.printAttributes();

  Edge[] personGroup = getPersonGroup(10,10,10); 
  int whichPerson = (int)random(personGroup.length);
  println("Chosen person is " + personGroup[whichPerson].newName);
}

public Edge[] getPersonGroup(int tot1, int tot2, int tot3) {
  Edge[] personGroup1 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person/n", tot1, 0);
  Edge[] personGroup2 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person", tot2, 0);
  Edge[] personGroup3 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/human", tot3, 0);
  println("- GROUP 1 -");
  listEdgeNames(personGroup1);
  println("- GROUP 2 -");
  listEdgeNames(personGroup2);
  println("- GROUP 3 -");
  listEdgeNames(personGroup3);

  Edge[] personSubTotal = (Edge[])concat(personGroup1, personGroup2);
  Edge[] personTotal = (Edge[])concat(personSubTotal, personGroup3);
  println("- TOTAL -");
  listEdgeNames(personTotal);
  return personTotal;
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
  if (!relTrue && offsetNum > 0) {//offsetTrue) {
    newPath = path + searchObject + "?limit=" + limitNum + "&offset=" + offsetNum + "&filter=/c/en";
  } 
  println("calculated path is " + newPath); 
  return newPath;
} 

//get edges at offset number optionally defined by a relationship (i.e. "/r/IsA"), 
public Edge[] getSomeEdgeOf(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum) {
  unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  JSONArray jsonEdges = unownedJson.getJSONArray("edges");
  JSONObject edge;
  String startLemmas, endLemmas, start, end, rel;
  String newName = "";
  Edge[] theseEdges = new Edge[jsonEdges.size()];

  for (int i = 0; i < theseEdges.length; i++) { 
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

    theseEdges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newName);
  }
  return theseEdges;
}

public int getNumFound(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum) {
  unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  int numFound = unownedJson.getInt("numFound");
  return numFound;
} 

public void listEdgeNames(Edge[] edges) { 
  for (int i = 0; i < edges.length; i++) {
    println(edges[i].newName);
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

