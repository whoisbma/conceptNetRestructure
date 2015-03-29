final int edgeLimit = 3; 
final String path = "http://conceptnet5.media.mit.edu/data/5.2";

final String REL_IS_A = "/r/IsA";
final String REL_USED_FOR = "/r/UsedFor";

//final String TARGET = "/c/en/money";
final String TARGET = "money";

Edge[] unownedEdges;
JSONObject unownedJson;

int levelDepth = 5;

int[] resultsTracker = new int[levelDepth];
ArrayList<int[]> successes;

//CNObject object;

void setup() { 
  size(400, 400); 
  background(#EEEEEE); 
  frameRate(30);

  for (int i = 0; i < resultsTracker.length; i++) {
    resultsTracker[i] = 0;  //just double-checking....
  } 
  
  successes = new ArrayList<int[]>();

  Edge[] personGroup = getPersonGroup(10,10,10); 
  int whichPerson = (int)random(personGroup.length);
  println("Chosen person is " + personGroup[whichPerson].newName);
  String chosenStart = personGroup[whichPerson].finalPath;
  println(chosenStart);
  
  recurseCheck(levelDepth, chosenStart);
  
  println(successes.size());
}


//start with "person" path
  //get all edges related to Person
    //for each Person edge, get all Edges
      //for each of those edges, etc.

//create an array of numbers to store each path chosen. -i.e. results[8], results[124], results[13], --> 8, 124, 13
//until a success is registered. get the level depth at that point, and push the array of numbers to an arraylist of success cases

//resultsTracking[level1,level2,level3,level4,

public void recurseCheck(int level, String conceptPath) {
  Edge[] results = getSomeEdgeOf(false, "", "", conceptPath, edgeLimit, 0);
  for (int i = 0; i < results.length; i++) {
    resultsTracker[levelDepth-level] = i; 
    if (results[i].finalPath.contains(TARGET)) {
      println("SUCCESS!!! at " + results[i].newName);
      //println(resultsTracker); 
      successes.add(resultsTracker); 
    } else { 
      println("not found at " + results[i].newName);
      //println(resultsTracker); 
    }
  }
  if (level > 1) { 
    level--;
    for (int i = 0; i < results.length; i++) {
      recurseCheck(level, results[i].finalPath);
    }
  } 
} 

//public void getEdgesAndCheck(String currentConcept) { 
//  Edge[] results = getSomeEdgeOf(false, "", "", currentConcept, 10, 0); 
//  listEdgeNames(results);
//  for (int i = 0; i < results.length; i++) {
//    if (results[i].equals(TARGET)) {
//      println("SUCCESS!!! at " + results[i]);
//    } 
//  }
//}


public Edge[] getPersonGroup(int tot1, int tot2, int tot3) {
  Edge[] personGroup1 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person/n", tot1, 0);
  Edge[] personGroup2 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person", tot2, 0);
  Edge[] personGroup3 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/human", tot3, 0);
//  println("- GROUP 1 -");
//  listEdgeNames(personGroup1);
//  println("- GROUP 2 -");
//  listEdgeNames(personGroup2);
//  println("- GROUP 3 -");
//  listEdgeNames(personGroup3);

  Edge[] personSubTotal = (Edge[])concat(personGroup1, personGroup2);
  Edge[] personTotal = (Edge[])concat(personSubTotal, personGroup3);
//  println("- TOTAL -");
//  listEdgeNames(personTotal);
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
  //println("calculated path is " + newPath); 
  return newPath;
} 

//get edges at offset number optionally defined by a relationship (i.e. "/r/IsA"), 
public Edge[] getSomeEdgeOf(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum) {
  unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  JSONArray jsonEdges = unownedJson.getJSONArray("edges");
  JSONObject edge;
  String startLemmas, endLemmas, start, end, rel;
  String newName = "";
  String finalPath = "";
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
      finalPath = start;
    } else if (start.contains(otherObject)) {
      String splitString[] = split(end, "/");
      //println(splitString[3] + " (end)");
      newName = splitString[3];
      finalPath = end;
    } else { 
      newName = "???";
      finalPath = "???";
    }

    theseEdges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newName, finalPath);
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

