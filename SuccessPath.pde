class SuccessPath { 
  
  public String start;
  public String end; 
  public int[] path = new int[levelDepth];
  public String[] pathWords; 
  public float rand; 

  public SuccessPath(String start, String end, int[] path) {
    this.start = start;
    this.end = end;
    this.path = path;
//    for (int i = 0; i < this.path.length; i++) {
//      this.path[i] = (int)random(10); 
//    } 
    this.rand = random(100); 
    //convert path[] to pathWords[] here

  }

  
} 
