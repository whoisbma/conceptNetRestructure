final int edgeLimit = 10; 
final int levelDepth = 3;
final String path = "http://conceptnet5.media.mit.edu/data/5.2";

final String REL_IS_A = "/r/IsA";
//final String REL_USED_FOR = "/r/UsedFor";

//final String TARGET = "/c/en/money";
final String TARGET = "person";

Edge[] unownedEdges;
JSONObject unownedJson;

int[] resultsTracker = new int[levelDepth];
ArrayList<SuccessPath> successes;

//CNObject object;

void setup() { 
  size(400, 400); 
  background(#EEEEEE); 
  frameRate(30);

  for (int i = 0; i < resultsTracker.length; i++) {
    resultsTracker[i] = 9999;  //because node 0 is a success case
  } 

  successes = new ArrayList<SuccessPath>();

  Edge[] personGroup = getPersonGroup(10, 10, 10); 
  int whichPerson = (int)random(personGroup.length);
  println("Chosen person is " + personGroup[whichPerson].newName);
  String chosenStart = personGroup[whichPerson].finalPath;
  println(chosenStart);

  recurseCheck(levelDepth, chosenStart);

  println(successes.size());
  for (int i = 0; i < successes.size (); i++) {
    SuccessPath success = successes.get(i);
    println(i);
    println(success.rand); 
    println(success.path[0] + " " + success.path[1] + " " + success.path[2] + " ");// + success.path[3] + " " + success.path[4] + " " + success.path[5] + " " + success.path[6]);
  }

  //checkSuccesses(chosenStart);
}

public void checkSuccesses(String startingObject) {
  println("checking successes"); 
  for (int i = 0; i < successes.size (); i++) { 
    SuccessPath success = successes.get(i);
    for (int j = 0; j < levelDepth; j++) { 
      try { 
        Edge[] tempEdge = getSomeEdgeOf(false, "", "", startingObject, 1, success.path[j]);
        print(tempEdge[0].newName + "   ");
      } 
      catch (NullPointerException e) {
        e.printStackTrace();
      }
    }
    println();
  }
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

  if (results != null) { 
    for (int i = 0; i < results.length; i++) {
      int l = levelDepth - level;
      println("level: " + l + ", node: " + i);
      resultsTracker[l] = i; 
      if (results[i].finalPath.contains(TARGET)) {
        println("SUCCESS at " + results[i].newName);
        println("resultstracker array -> " + resultsTracker[0] + " " + resultsTracker[1] + " " + resultsTracker[2]);// + " " + resultsTracker[3] + " " + resultsTracker[4] + " " + resultsTracker[5] + " " + resultsTracker[6]); 
        SuccessPath success = new SuccessPath("person", "money", resultsTracker);
        successes.add(success); 
        println("successpath obj -> " + success.path[0] + " " + success.path[1] + " " + success.path[2]);// + " " + success.path[3] + " " + success.path[4] + " " + success.path[5] + " " + success.path[6]);
      } else { 
        //println("not found at " + results[i].newName);
        println("resultstracker array -> " + resultsTracker[0] + " " + resultsTracker[1] + " " + resultsTracker[2]);// + " " + resultsTracker[3] + " " + resultsTracker[4] + " " + resultsTracker[5] + " " + resultsTracker[6]);
      }
    }
    if (level > 1) { 
      level--;
      for (int i = 0; i < results.length; i++) {
        recurseCheck(level, results[i].finalPath);
      }
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
  try { 
    unownedJson = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  } 
  catch (NullPointerException e) {
    e.printStackTrace();
    return null;
  } 
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

